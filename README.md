### 📜 Автоматическая настройка LAMP-сервера с поддержкой HTTPS и HTTP/2

Этот bash-скрипт предназначен для быстрого развёртывания веб-сервера на **чистой Debian-подобной машине**.
Он автоматически устанавливает и настраивает стек LAMP, включает `php-fpm`, `HTTP/2`, `HTTPS`, а также создаёт bash-функцию для добавления новых сайтов на поддоменах.

---

#### 🛠 Что делает скрипт

* Обновляет систему и устанавливает необходимые пакеты: `apache2`, `php`, `mysql`, `certbot`, `php-fpm` и др.
* Настраивает Apache:
* Меняет конфигурацию Apache (`-Indexes`) для повышения безопасности;
* Настраивает SSH: запрещает вход по паролю;
* Активирует Let's Encrypt и регистрирует почту;
* Добавляет bash-функцию `make-site`, которая:
  * создаёт Apache-конфиг на основе шаблона;
  * создаёт директорию для сайта;
  * копирует стартовые файлы;
  * активирует сайт и перезапускает Apache;
  * автоматически получает HTTPS-сертификат;
* Добавляет `make-site` в `.bashrc` для последующего использования;

---

#### 🚀 Использование

1. Загрузите архив на сервер (init.tar.gz), распакуйте.

2. Выполните скрипт, передав основной домен:

   ```bash
   sudo ./script example.com
   ```

3. После завершения используйте `make-site` для создания поддоменов:

   ```bash
   make-site blog
   ```

   Это создаст сайт `blog.example.com` и сразу подключит HTTPS.

---

#### ⚙️ Требования

* debian-подобный дистрибутив
* Привилегии `sudo`
* Зарегистрированный домен и доступ к управлению DNS (A-записи)

---

#### 🧠 Автор

Скрипт написан вручную в рамках обучения и практики развёртывания серверной инфраструктуры.
В процессе были изучены и применены:

* bash и автоматизация CLI;
* управление Apache и PHP-FPM;
* работа с Let's Encrypt и certbot;
* настройка DNS и HTTPS;
* безопасная конфигурация SSH;
* настройка многосайтовой структуры на одном сервере.
