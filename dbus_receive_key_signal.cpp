#include "dbus_receive_key_signal.h"
#include <QDebug>

DbusControlPanel::DbusControlPanel(QObject *parent) : QObject(parent) {}

void DbusControlPanel::key_ev_slot(const QString &keyname, const QString &actname) {
    qDebug() << "dbus message:" << keyname << actname;
    return;
}
