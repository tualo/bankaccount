<?php

namespace Tualo\Office\BankAccount\Routes;

use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\DS\DSReadRoute;
use Fhp\Options\FinTsOptions;
use Fhp\FinTs;
use Fhp\Options\Credentials;
use Tualo\Office\BankAccount\TualoFinTS;

class SyncBLZ implements IRoute
{
    public static function register()
    {
        BasicRoute::add('/blz/sync', function ($matches) {
            $db = App::get('session')->getDB();
            try {
                file_get_contents("httsp://tualo.de/downloads/BLZ2.txt");
                App::result('success', true);
            } catch (\Exception $e) {
                App::result('last_sql', $db->last_sql);
                App::result('msg', $e->getMessage());
            }
            App::contenttype('application/json');
        }, ['get', 'post'], true);


    }
}
