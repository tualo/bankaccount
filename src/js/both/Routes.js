Ext.Loader.setPath('Tualo.bankaccount.lazy', './jsbankaccount');

Ext.define('Tualo.routes.BankAccount',{
    statics: {
        load: async function() {
            return [
                {
                    name: 'bankaccount',
                    path: '#bankaccount'
                }
            ]
        }
    },  
    url: 'bankaccount',
    handler: {
        action: function( ){
            Ext.getApplication().addView('Tualo.bankaccount.lazy.Viewport');
        },
        before: function (action) {
            action.resume();
        }
    }
});