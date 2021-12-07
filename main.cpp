#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
//--for xml read.begin
#include "logger.h"
#include "loggerconf.h"
#include <libxml/parser.h>
#include <unistd.h>
//--for xml read.end
//--for x event-begin
#include "controlpanelconnector.h"
#include <fcntl.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <xcb/xcb_event.h>
#include <xcb/xcb_keysyms.h>

#define LENGTH(x) (sizeof(x) / sizeof(*x))
#define MAXLEN 256

#ifdef DEBUG
#define PUTS(x) puts(x)
#define PRINTF(x, ...) printf(x, __VA_ARGS__)
#else
#define PUTS(x) ((void)0)
#define PRINTF(x, ...) ((void)0)
#endif

#define CONFIG_HOME_ENV "XDG_CONFIG_HOME"
#define SXHKD_SHELL_ENV "SXHKD_SHELL"
#define SHELL_ENV "SHELL"
#define CONFIG_PATH "sxhkd/sxhkdrc"
#define HOTKEY_PREFIX 'H'
#define COMMAND_PREFIX 'C'
#define BEGIN_CHAIN_PREFIX 'B'
#define END_CHAIN_PREFIX 'E'
#define TIMEOUT_PREFIX 'T'
#define TIMEOUT 3

xcb_connection_t *dpy;
xcb_window_t root;
xcb_key_symbols_t *symbols;

char *shell;
char config_file[MAXLEN];
char *config_path;
char **extra_confs;
int num_extra_confs;
int redir_fd;
FILE *status_fifo;
char progress[3 * MAXLEN];
int mapping_count;
int timeout;

bool running, grabbed, toggle_grab, reload, bell, chained, locked;
xcb_keysym_t abort_keysym;

uint16_t num_lock;
uint16_t caps_lock;
uint16_t scroll_lock;
//--for x event-begin.end

void warn(char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
}

__attribute__((noreturn)) void err(char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    exit(EXIT_FAILURE);
}

int16_t modfield_from_keycode(xcb_keycode_t keycode) {
    uint16_t modfield = 0;
    xcb_keycode_t *mod_keycodes = NULL;
    xcb_get_modifier_mapping_reply_t *reply = NULL;
    if ((reply = xcb_get_modifier_mapping_reply(dpy, xcb_get_modifier_mapping(dpy), NULL)) != NULL &&
        reply->keycodes_per_modifier > 0) {
        if ((mod_keycodes = xcb_get_modifier_mapping_keycodes(reply)) != NULL) {
            unsigned int num_mod = xcb_get_modifier_mapping_keycodes_length(reply) / reply->keycodes_per_modifier;
            for (unsigned int i = 0; i < num_mod; i++) {
                for (unsigned int j = 0; j < reply->keycodes_per_modifier; j++) {
                    xcb_keycode_t mkc = mod_keycodes[i * reply->keycodes_per_modifier + j];
                    if (mkc == XCB_NO_SYMBOL)
                        continue;
                    if (keycode == mkc)
                        modfield |= (1 << i);
                }
            }
        }
    }
    free(reply);
    return modfield;
}

void parse_event(xcb_generic_event_t *evt, uint8_t event_type, xcb_keysym_t *keysym, xcb_button_t *button,
                 uint16_t *modfield) {
    if (event_type == XCB_KEY_PRESS) {
        xcb_key_press_event_t *e = (xcb_key_press_event_t *)evt;
        xcb_keycode_t keycode = e->detail;
        *modfield = e->state;
        *keysym = xcb_key_symbols_get_keysym(symbols, keycode, 0);
        PRINTF("key press %u %u\n", keycode, *modfield);
    } else if (event_type == XCB_KEY_RELEASE) {
        xcb_key_release_event_t *e = (xcb_key_release_event_t *)evt;
        xcb_keycode_t keycode = e->detail;
        *modfield = e->state & ~modfield_from_keycode(keycode);
        *keysym = xcb_key_symbols_get_keysym(symbols, keycode, 0);
        PRINTF("key release %u %u\n", keycode, *modfield);
    } else if (event_type == XCB_BUTTON_PRESS) {
        xcb_button_press_event_t *e = (xcb_button_press_event_t *)evt;
        *button = e->detail;
        *modfield = e->state;
        PRINTF("button press %u %u\n", *button, *modfield);
    } else if (event_type == XCB_BUTTON_RELEASE) {
        xcb_button_release_event_t *e = (xcb_button_release_event_t *)evt;
        *button = e->detail;
        *modfield = e->state;
        PRINTF("button release %u %u\n", *button, *modfield);
    }
}

#define KEYSYMS_PER_KEYCODE 4
#define MOD_STATE_FIELD 255
#define ESCAPE_KEYSYM 0xff1b
#define SYNCHRONOUS_CHAR ';'

void key_button_event(xcb_generic_event_t *evt, uint8_t event_type) {
    xcb_keysym_t keysym = XCB_NO_SYMBOL;
    xcb_button_t button = XCB_NONE;
    bool replay_event = false;
    uint16_t modfield = 0;
    uint16_t lockfield = num_lock | caps_lock | scroll_lock;
    parse_event(evt, event_type, &keysym, &button, &modfield);
    modfield &= ~lockfield & MOD_STATE_FIELD;
    if (keysym != XCB_NO_SYMBOL || button != XCB_NONE) {
        // hotkey_t *hk = find_hotkey(keysym, button, modfield, event_type, &replay_event);
        qDebug() << "" << keysym;
        //        if (hk != NULL) {
        //            run(hk->command, hk->sync);
        //            put_status(COMMAND_PREFIX, hk->command);
        //        }
    }
    switch (event_type) {
    case XCB_BUTTON_PRESS:
    case XCB_BUTTON_RELEASE:
        if (replay_event)
            xcb_allow_events(dpy, XCB_ALLOW_REPLAY_POINTER, XCB_CURRENT_TIME);
        else
            xcb_allow_events(dpy, XCB_ALLOW_SYNC_POINTER, XCB_CURRENT_TIME);
        break;
    case XCB_KEY_PRESS:
    case XCB_KEY_RELEASE:
        if (replay_event)
            xcb_allow_events(dpy, XCB_ALLOW_REPLAY_KEYBOARD, XCB_CURRENT_TIME);
        else
            xcb_allow_events(dpy, XCB_ALLOW_SYNC_KEYBOARD, XCB_CURRENT_TIME);
        break;
    }
    xcb_flush(dpy);
}

void setup(void) {
    qDebug() << "xcb setup";
    int screen_idx;
    dpy = xcb_connect(NULL, &screen_idx);
    if (xcb_connection_has_error(dpy))
        err("Can't open display.\n");
    xcb_screen_t *screen = NULL;
    xcb_screen_iterator_t screen_iter = xcb_setup_roots_iterator(xcb_get_setup(dpy));
    for (; screen_iter.rem; xcb_screen_next(&screen_iter), screen_idx--) {
        if (screen_idx == 0) {
            screen = screen_iter.data;
            break;
        }
    }
    if (screen == NULL)
        err("Can't acquire screen.\n");
    root = screen->root;
    if ((shell = getenv(SXHKD_SHELL_ENV)) == NULL && (shell = getenv(SHELL_ENV)) == NULL)
        err("The '%s' environment variable is not defined.\n", SHELL_ENV);
    symbols = xcb_key_symbols_alloc(dpy);
    progress[0] = '\0';
    // below is not belong to setup
    // grab();

    xcb_generic_event_t *evt;
    int fd = xcb_get_file_descriptor(dpy);

    fd_set descriptors;

    reload = toggle_grab = bell = chained = locked = false;
    running = true;

    xcb_flush(dpy);

    FD_ZERO(&descriptors);
    FD_SET(fd, &descriptors);
    while (running) {
        if (select(fd + 1, &descriptors, NULL, NULL, NULL) > 0) {
            while ((evt = xcb_poll_for_event(dpy)) != NULL) {
                uint8_t event_type = XCB_EVENT_RESPONSE_TYPE(evt);
                switch (event_type) {
                case XCB_KEY_PRESS:
                case XCB_KEY_RELEASE:
                case XCB_BUTTON_PRESS:
                case XCB_BUTTON_RELEASE:
                    key_button_event(evt, event_type);
                    break;
                case XCB_MAPPING_NOTIFY:
                    break;
                default:
                    PRINTF("received event %u\n", event_type);
                    break;
                }
                free(evt);
            }
        }

        if (xcb_connection_has_error(dpy)) {
            warn("The server closed the connection.\n");
            running = false;
        }
    }

    return;
}

char *xml_file = "/usr/local/etc/stimuli_mapping.xml";
/*
int get_xml_config_file(void) {
    const char *s_stimuli_name = "stimuli_name";
    const char *s_stimuli_code = "stimuli_code";
    const char *s_combination = "combination";

    if (0 != access(xml_file, F_OK | R_OK)) {
        LOG_ERROR("input manager xml file not exist! %s\n", xml_file);
        return -1;
    }
    LOG_INFO("start read and parse xml file:%s", xml_file);
    xmlDoc *document;
    xmlNode *root, *first_child, *item;
    char stimuli_name[64] = {0};
    char stimuli_code[64] = {0};
    char combination[64] = {0};
    unsigned int modifier;
    xcb_keysym_t keysym;
    document = xmlReadFile(xml_file, NULL, 0);
    root = xmlDocGetRootElement(document);
    first_child = root->children;
    int c = 0;
    for (item = first_child; item; item = item->next) {
        memset(stimuli_name, 0, sizeof(stimuli_name));
        memset(stimuli_code, 0, sizeof(stimuli_code));
        keysym = 0;
        modifier = 0;
        xmlAttr *attr = item->properties;
        if (attr && attr->name && attr->children) {
            LOG_DEBUG("attr-%s=%s\n", attr->name, xmlNodeListGetString(item->doc, attr->children, 1));
        }
        xmlNode *item_node;
        for (item_node = item->children; item_node; item_node = item_node->next) {
            if (XML_TEXT_NODE == item_node->type) {
                continue;
            } else {
                // 1. get combination + stimuli
                // 2. convert combination to keysym+keycode
                char *inner_text = xmlNodeGetContent(item_node);
                LOG_DEBUG("type=%d#<%s>::%s<<<\n", item_node->type, item_node->name, inner_text);
                if (!strcasecmp(s_stimuli_name, item_node->name)) {
                    memset(stimuli_name, 0, sizeof(stimuli_name));
                    strcpy(stimuli_name, inner_text);
                } else if (!strcasecmp(s_stimuli_code, item_node->name)) {
                    memset(stimuli_code, 0, sizeof(stimuli_code));
                    strcpy(stimuli_code, inner_text);
                } else if (!strcasecmp(s_combination, item_node->name)) {
                    printf("combination: %s\n", inner_text);
                    memset(combination, 0, sizeof(combination));
                    strcpy(combination, inner_text);
                    char *pos = combination;
                    char *s_key = NULL;
                    char *mod1 = combination;
                    char *mod2 = combination;
                    unsigned short plus_num = 0;

                    while (*pos != '\0') {
                        if ('+' == *pos++) {
                            plus_num++;
                        }
                    }
                    pos = combination;
                    if (0 != plus_num) {
                        s_key = strrchr(pos, '+');
                        *s_key = '\0';
                        s_key += 1;
                        if (1 < plus_num) {
                            mod2 = strchr(pos, '+');
                            *mod2 = '\0';
                            mod2 += 1;
                        }
                    } else {
                        s_key = pos;
                        mod1 = NULL;
                        mod2 = NULL;
                    }

                    char *mods[2] = {mod1, mod2};

                    for (int i = 0; i < plus_num; i++) {
                        char *mod = mods[i];
                        if (0 == strcasecmp(mod, "control") || 0 == strcasecmp(mod, "ctrl"))
                            modifier |= ControlMask;
                        else if (strcasecmp(mod, "shift") == 0)
                            modifier |= ShiftMask;
                        else if (strcasecmp(mod, "mod1") == 0 || strcasecmp(mod, "alt") == 0)
                            modifier |= Mod1Mask;
                        else if (strcasecmp(mod, "mod2") == 0)
                            modifier |= Mod2Mask;
                        else if (strcasecmp(mod, "mod3") == 0)
                            modifier |= Mod3Mask;
                        else if (strcasecmp(mod, "mod4") == 0 || strcasecmp(mod, "meta") == 0)
                            modifier |= Mod4Mask;
                        else if (strcasecmp(mod, "mod5") == 0)
                            modifier |= Mod5Mask;
                    }
                    LOG_DEBUG("add key(xml_version): mod=%s;key=%s\n", mod1, s_key);
                    keysym = XStringToKeysym(s_key);
                }
            }
        }
        if (0 != keysym && 0 != strlen(stimuli_name) && 0 != strlen(stimuli_code)) {
            add_key_xml_version(keysym, modifier, stimuli_code, stimuli_name);
        }
        if (c++ > 500)
            break;
    }
    xmlFreeDoc(document);
    xmlCleanupParser();
    return 0;
}
*/

#include "dbus_receive_key_signal.h"
#include <QDBusConnection>

#define DBUS_CP_SERVICE_NAME "com.esi.cpanel"
#define DBUS_CP_OBJ_NAME "/obj0"
int init_dbus() {
    qDebug() << "init debus";
    DbusControlPanel *dcp = new DbusControlPanel(); // no need to release.
    QDBusConnection sess_bus = QDBusConnection::sessionBus();

    if (!sess_bus.registerService(QString(DBUS_CP_SERVICE_NAME))) {
        qFatal("Could not register service!");
        return -1;
    }

    if (!sess_bus.registerObject(DBUS_CP_OBJ_NAME, dcp, QDBusConnection::ExportScriptableContents)) {
        qFatal("Could not register Chat object!");
        return -1;
    }
    // 21/12/07 support receive dbus signal from dbus-send
    // dbus-send --session --type=signal --dest=com.esi.cpanel /obj0 com.esi.cpanel.key_ev_sig string:'a' string:'05'
    sess_bus.connect(QString(), QString(), DBUS_CP_IFACE_NAME, "key_ev_sig", dcp, SLOT(key_ev_slot(QString, QString)));
    return 0;
}

int main(int argc, char *argv[]) {

    // setup();
    init_dbus();

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    QObject *qml_root = engine.rootObjects()[0];
    ControlPanelUiConnector *cpuc = new ControlPanelUiConnector(nullptr, qml_root);

    app.exec();

    return 0;
}
