<?php

namespace Tualo\Office\BankAccount\Checks;

use Tualo\Office\Basic\Middleware\Session;
use Tualo\Office\Basic\PostCheck;
use Tualo\Office\Basic\TualoApplication as App;



class Configuration  extends PostCheck {
    public static function test(array $config){
        $tables = [
            'kontoauszuege'=>[
                'columns'=>[
                ]
            ],
            'fints_accounts'=>[
                'columns'=>[
                ]
            ],
            'bankkonten'=>[
                'columns'=>[
                ]
            ],
        ];
        self::tableCheck('bankaccount',$tables);
        if (!isset($config['FHP_REGISTRATION_NO'])) self::formatPrintLn(['red'],"\t".'FHP_REGISTRATION_NO missed in configuration');
        if (!isset($config['FHP_SOFTWARE_VERSION'])) self::formatPrintLn(['red'],"\t".'FHP_SOFTWARE_VERSION missed in configuration');
    }
}