#!/usr/bin/env bash
COMPOSER_LOCK=./composer.lock
COMPOSER_ENV=
while true; do
echo -n "Is this develop environment? (y/n) > "
read is_dev
if [ "$is_dev" == "Y" ] || [ "$is_dev" == "y" ]; then
echo "You are setting ecomdev for DEV"
COMPOSER_ENV=
break;
else if [ "$is_dev" == "N" ] || [ "$is_dev" == "n" ]; then
echo "You aren't setting ecomdev for DEV"
COMPOSER_ENV=--no-dev
break;
fi
fi
done

PHPUNIT_LOCAL=./app/etc/local.xml.phpunit
PHPUNIT_CONFIG=./phpunit.xml
PHPUNIT_CONFIG_BASE=./phpunit.xml.dist
IS_INSTALL=0
if [ ! -f $COMPOSER_LOCK ]; then
composer install $COMPOSER_ENV
    else
composer update $COMPOSER_ENV
fi

if [ ! -f $PHPUNIT_LOCAL ] || [ ! -f $PHPUNIT_CONFIG_BASE ]; then
IS_INSTALL=1
fi
cd shell/
if [ $IS_INSTALL ]; then
    php ecomdev-phpunit.php -a install
fi
echo -n "Enter your database name for test > "
read database_name
echo -n "Enter your base url > "
read base_url
php ecomdev-phpunit.php -a magento-config --db-name $database_name --base-url $base_url
cd ../
phpunit
