#ifndef DBUS_OBJ_H
#define DBUS_OBJ_H

#include <QObject>

#define DBUS_CP_IFACE_NAME "com.esi.cpanel"

class DbusControlPanel : public QObject {
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", DBUS_CP_IFACE_NAME)
  public:
    explicit DbusControlPanel(QObject *parent = nullptr);

  Q_SIGNALS:
    Q_SCRIPTABLE void key_ev_sig(const QString &keyname, const QString &actname);
  public Q_SLOTS:
    Q_SCRIPTABLE void key_ev_slot(const QString &keyname, const QString &actname);
};

#endif // DBUS_OBJ_H
