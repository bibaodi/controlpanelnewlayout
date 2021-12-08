#include "controlpanelconnector.h"

ControlPanelUiConnector::ControlPanelUiConnector(QObject *parent, QObject *root) : QObject(parent), m_rootItem(root) {
    if (!root) {
        qDebug() << "Err: root item is null";
        return;
    }

    QObject *item = root->findChild<QObject *>("btn_select");
    QObject *item2 = root->findChild<QObject *>("btn_translate");
    QObject *item3 = root->findChild<QObject *>("item_instance");

    if (!item3) {
        qDebug() << "item3 is not valid";
    } else {
        const QMetaObject *metaObj = item3->metaObject();
        for (int i = 0; i < metaObj->methodCount(); ++i) {
            QMetaMethod method = metaObj->method(i);
            qDebug() << method.methodSignature();
        }
    }

    QObject::connect(item, SIGNAL(qmlSignal(QString)), this, SLOT(cppSlot(QString)));
    QObject::connect(item2, SIGNAL(qmlSignal(int)), this, SLOT(cppSlot(int)));
    QObject::connect(item3, SIGNAL(qmlSignal3(QVariant)), this, SLOT(cppSlot3(QVariant)));
}

void ControlPanelUiConnector::cppSlot(const QString &msg) { qDebug() << "cpp received signal from qml: " << msg; }
void ControlPanelUiConnector::cppSlot(const int msg) { qDebug() << "cpp received signal from qml: " << msg; }
void ControlPanelUiConnector::cppSlot3(QVariant vitem) {
    // QQuickItem *item = qvariant_cast<QQuickItem *>(vitem.value(Qt::UserRole));
    // QQuickItem item = (QQuickItem)vitem;
    qDebug() << "Called the C++ slot with item:" << vitem;
    // qDebug() << "Item dimensions:" << item->width() << item->height();
}

void ControlPanelUiConnector::key_ev_slot(const QString &key_stcode, const QString &key_infos) {
    QStringList list2 = key_infos.split(QLatin1Char(':'), Qt::SkipEmptyParts);
    qDebug() << "code:" << key_stcode << ", infos:" << key_infos << ",splits:" << list2;
    if (list2.length() < 3 || list2[1].length() < 1 || list2[2].length() < 4) {
        return;
    }
    QString key_text = list2[1];
    QString key_action = list2[2];
    int try_num = 5;
    while (try_num > 0) {
        QString key_objectName;
        switch (try_num--) {
        case 5: {
            key_objectName = key_text.toLower();
            break;
        }
        case 4: {
            key_objectName = key_text.toUpper();
            break;
        }
        case 3: {
            if (key_text.length() < 2)
                return;
            key_objectName = key_text.at(0).toUpper() + key_text.right(key_text.length() - 1).toLower();
            break;
        }
        case 2: {
            if (key_text.length() < 3)
                return;
            key_objectName = key_text.at(0).toLower() + key_text.mid(1, 1).toUpper() +
                             key_text.right(key_text.length() - 2).toLower();
            break;
        }
        default:
            return;
        }
        if (key_objectName.length() < 1) {
            return;
        }
        QList<QQuickItem *> all_objs = m_rootItem->findChildren<QQuickItem *>(key_objectName);
        for (int i = 0; i < all_objs.length(); i++) {
            qDebug() << all_objs[i];
            QQuickItem *cp_btn = all_objs[i];
            QVariant property_value(true);
            if (QString("press") == key_action.toLower()) {
                if (property_value == cp_btn->property("highlighted")) {
                    cp_btn->setProperty("highlighted", false);
                } else {
                    cp_btn->setProperty("highlighted", true);
                }
            } else if (QString("left") == key_action.toLower()) {
                if (property_value == cp_btn->property("highlighted")) {
                    cp_btn->setProperty("testing_left_show", false);
                } else {
                    cp_btn->setProperty("testing_left_show", true);
                }
            } else if (QString("right") == key_action.toLower()) {
                if (property_value == cp_btn->property("highlighted")) {
                    cp_btn->setProperty("testing_right_show", false);
                } else {
                    cp_btn->setProperty("testing_right_show", true);
                }
            }
        }
    }
}
