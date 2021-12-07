#include "dbus_obj.h"
#include <QDebug>

DbusControlPanel::DbusControlPanel(QObject *parent) : QObject(parent) {}

void DbusControlPanel::key_ev_slot(const QString &keyname, const QString &actname) {
    qDebug() << "key_ev_slot message:" << keyname << actname;
    return;
}
