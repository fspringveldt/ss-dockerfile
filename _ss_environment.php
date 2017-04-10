<?php
    /**
     * Created by PhpStorm.
     * User: francospringveldt
     * Date: 2017/02/23
     * Time: 8:26 AM
     */
    /* What kind of environment is this: development, test, or live (i.e. production)? */
    define('SS_ENVIRONMENT_TYPE', getenv('SS_ENVIRONMENT') ?: 'live');
    /* Database connection */
    //NB: You can substitute getenv() with string values of your choice if you choose.
    define('SS_DATABASE_SERVER', getenv('DATABASE_SERVER'));
    define('SS_DATABASE_NAME', getenv('MYSQL_DATABASE'));
    define(
        'SS_DATABASE_USERNAME', getenv(
            'MYSQL_USER'
        )
    );
    define('SS_DATABASE_PASSWORD', getenv('MYSQL_PASSWORD'));
    /* Configure a default username and password to access the CMS on all sites in this environment. */
    define('SS_DEFAULT_ADMIN_USERNAME', getenv('SS_DEFAULT_ADMIN_USERNAME'));
    define('SS_DEFAULT_ADMIN_PASSWORD', getenv('SS_DEFAULT_ADMIN_PASSWORD'));
    $host = sprintf('http://%s', getenv('VIRTUAL_HOST'));
    global $_FILE_TO_URL_MAPPING;
    $_FILE_TO_URL_MAPPING['/var/www/html'] = $host;
