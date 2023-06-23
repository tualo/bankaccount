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

class Route implements IRoute
{
    public static function register()
    {
        BasicRoute::add('/bankaccount/fints2clean', function ($matches) {
            $db = App::get('session')->getDB();
            try {
                $sessionfile = App::get('tempPath') . '/' . '.ht_fints_state';
                if (file_exists($sessionfile)) {
                    unlink($sessionfile);
                }
                App::result('success', true);
            } catch (\Exception $e) {
                App::result('last_sql', $db->last_sql);
                App::result('msg', $e->getMessage());
            }
            App::contenttype('application/json');
        }, ['get', 'post'], true);


        BasicRoute::add('/bankaccount/update', function ($matches) {

            $db = App::get('session')->getDB();
            try {
                if (!class_exists("\Fhp\Options\Credentials")) {
                    throw new \Exception("fints not installed");
                }
                if (!defined('FHP_REGISTRATION_NO')) {
                    throw new \Exception('FinTS Produktcode fehlt');
                }
                if (!defined('FHP_SOFTWARE_VERSION')) {
                    throw new \Exception('FinTS Produktversion fehlt');
                }

                if (!isset($_REQUEST['usepin'])) {
                    throw new \Exception('Das Passwort fehlt');
                }
                if (!isset($_REQUEST['useaccount'])) {
                    throw new \Exception('Das Account fehlt');
                }

                include_once __DIR__ . '/classes/FinTS.php';

                $fints_account = DSReadRoute::readSingleItem($db, 'fints_accounts', array(
                    'filter' => array(
                        array(
                            'property' => 'fints_accounts__id',
                            'operator' => 'eq',
                            'value' => $_REQUEST['useaccount']
                        )
                    )
                ));
                if ($fints_account === false) throw new \Exception('Das Konto konnte nicht ermittelt werden');


                $options = new FinTsOptions();
                $options->productName = App::get('configuration')['FHP_REGISTRATION_NO'];
                $options->productVersion = App::get('configuration')['FHP_SOFTWARE_VERSION'];
                $options->url = $fints_account['fints_accounts__url'];
                $options->bankCode = $fints_account['fints_accounts__code'];
                $credentials = Credentials::create($fints_account['fints_accounts__banking_username'], $_REQUEST['usepin']);

                $persistedInstance = $persistedAction = null;


                $sessionfile = App::get('tempPath') . '/' . '.ht_fints_state';
                if (file_exists($sessionfile)) {

                    list($persistedInstance, $persistedAction) = unserialize(file_get_contents($sessionfile));
                }
                $fints = FinTs::new($options, $credentials, $persistedInstance);
                $response = TualoFinTS::handleRequest($_REQUEST, $fints, $db, $persistedAction);
                file_put_contents($sessionfile, serialize([$fints->persist(), $persistedAction]));

                App::result('response', $response);
                App::result('success', true);
            } catch (\Exception $e) {

                App::result('last_sql', $db->last_sql);
                App::result('msg', $e->getMessage());
            }
            App::contenttype('application/json');
        }, ['get', 'post'], true);
    }
}
