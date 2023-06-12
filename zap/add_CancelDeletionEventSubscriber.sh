#!/bin/bash

php bin/template_jp.php
#rm -rf app/Plugin/*
echo '<?php
namespace Eccube\Doctrine\EventSubscriber;
use Doctrine\Common\EventSubscriber;
use Doctrine\ORM\Event\LifecycleEventArgs;
use Doctrine\ORM\Events;
class CancelDeletionEventSubscriber implements EventSubscriber
{
  public function getSubscribedEvents()
  {
    return [Events::preRemove];
  }
  public function preRemove(LifecycleEventArgs $event)
  {
    $event->getEntityManager()->detach($event->getEntity());
  }
}' > CancelDeletionEventSubscriber.php
sed -i.bak -e 's_$fs->remove_// $fs->remove_' src/Eccube/Controller/Admin/Content/PageController.php
rm -f app/config/eccube/packages/dev/web_profiler.yaml
bin/console doctrine:database:create --env=dev
bin/console doctrine:schema:create --env=dev
bin/console eccube:fixtures:load --env=dev
chmod -R 777 html
