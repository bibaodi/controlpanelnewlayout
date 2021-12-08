#ifndef SIGNALSLOTLISTVIEW_H
#define SIGNALSLOTLISTVIEW_H

#include <QDebug>
#include <QObject>

#include <QQuickItem>

class ControlPanelUiConnector : public QObject {
    Q_OBJECT
  public:
    explicit ControlPanelUiConnector(QObject *parent = 0, QObject *root = nullptr);
    QObject *m_rootItem;

  signals:

  public slots:
    void cppSlot(const QString &msg);
    void cppSlot(const int msg);
    void cppSlot3(QVariant item);
    void key_ev_slot(const QString &key_stcode, const QString &key_infos);
};

#endif // SIGNALSLOTLISTVIEW_H
