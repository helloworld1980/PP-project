Symfony Demo Application
========================

The "Symfony Demo Application" is a reference application created to show how
to develop Symfony applications following the recommended best practices.

Requirements
------------

  * PHP 7.1.3 or higher;
  * PDO-SQLite PHP extension enabled;

Installation
------------

Execute this command to install the project:

```bash
$ composer create-project symfony/symfony-demo
```

Usage
-----

There's no need to configure anything to run the application. Just execute this


```bash
$ cd symfony-demo/
$ php bin/console server:run
```


Tests
-----


```bash
$ cd symfony-demo/
$ ./vendor/bin/simple-phpunit
```

[1]: https://symfony.com/doc/current/reference/requirements.html
[2]: https://symfony.com/doc/current/cookbook/configuration/web_server_configuration.html
