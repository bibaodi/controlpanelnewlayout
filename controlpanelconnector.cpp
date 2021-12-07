#include "controlpanelconnector.h"

ControlPanelUiConnector::ControlPanelUiConnector(QObject *parent, QObject *root) : QObject(parent), qml_root(root) {
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
