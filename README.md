# 18.4 Виртуализация и контейнеризация.  Никулин Александр
# Домашнее задание к занятию 5. «Практическое применение Docker»

<details>
  <summary>Инструкция от форкнутого репозитория</summary>

  # shvirtd-example-python

  Example Flask-application for docker compose training.
  ## Installation
  First, you need to clone this repository:
  
  ```bash
  git clone https://github.com/netology-code/shvirtd-example-python.git
  ```
  
  Now, we will need to create a virtual environment and install all the dependencies:
  
  ```bash
  python3 -m venv venv  # on Windows, use "python -m venv venv" instead
  . venv/bin/activate   # on Windows, use "venv\Scripts\activate" instead
  pip install -r requirements.txt
  python main.py
  ```
  You need to run Mysql database and provide following ENV-variables for connection:  
  - DB_HOST (default: '127.0.0.1')
  - DB_USER (default: 'app')
  - DB_PASSWORD (default: 'very_strong')
  - DB_NAME (default: 'example')
  
  The applications will always running on http://localhost:5000.  
  To exit venv just type ```deactivate```
  
  ## License
  
  This project is licensed under the MIT License (see the `LICENSE` file for details).

  
</details>

## Задача 0
<details>
  <summary>Условия</summary>

  1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
  ```
  Command 'docker-compose' not found, but can be installed with:
  
  sudo snap install docker          # version 24.0.5, or
  sudo apt  install docker-compose  # version 1.25.0-1
  
  See 'snap info docker' for additional versions.
  ```
  В случае наличия установленного в системе ```docker-compose``` - удалите его.  
  2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  
  
</details>
  
<details>
  <summary>Решение</summary>
    
  ![image](https://github.com/user-attachments/assets/efdffb45-2e79-4f9f-bd73-817a24c4769d)
  ![image](https://github.com/user-attachments/assets/d0164da7-79e2-4fd4-be49-b48f95e84b1b)
    
</details>

## Задача 1
<details>
  <summary>Условия</summary>

  1. Сделайте в своем github пространстве fork репозитория ```https://github.com/netology-code/shvirtd-example-python/blob/main/README.md```.   
  2. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ ```python:3.9-slim```. Протестируйте корректность сборки. Не забудьте dockerignore. 
  3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
  4. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.
</details>

<details>
  <summary>Решение</summary>

  * Подготовил текущую репу.
  * Подготовил файлы
    ** ![image](https://github.com/user-attachments/assets/ba6e0490-10ca-4077-b55e-e2daa21224ae)
    ** Докер файл 
      ```dockerfile
      FROM python:3.9-slim
  
      ENV DB_HOST=127.0.0.1
      ENV DB_TABLE=requests
      ENV DB_USER=root
      ENV DB_NAME=db1
      ENV DB_PASSWORD=12345
      
      WORKDIR /app
      COPY requirements.txt ./
      RUN pip install -r requirements.txt
      COPY main.py ./
      CMD ["python", "main.py"]
      ```
  * Собрал образ
  * ![image](https://github.com/user-attachments/assets/1e6ee776-5064-4a6f-9fb1-b5fcb688bf20)
    
</details>

## Задача 2 (*)
<details>
  <summary>Условия</summary>  
  
  1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool".
       [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
  2. Настройте аутентификацию вашего локального docker в yandex container registry.
  3. Соберите и залейте в него образ с python приложением из задания №1.
  4. Просканируйте образ на уязвимости.
  5. В качестве ответа приложите отчет сканирования.
  
</details>

<details>
  <summary>Решение</summary>

  * Настроил хранилище контейнеров
  * загрузил туда образ собранного прилоежния
  * ![image](https://github.com/user-attachments/assets/7d6c5ea7-8783-4bbe-813b-0b8c67f7f17a)
  * Запустил сканирование
  * ![image](https://github.com/user-attachments/assets/5f258a26-f99f-4cad-b6d6-68089365b730)
  * ![image](https://github.com/user-attachments/assets/f0a32ce7-bf1d-4318-859e-fd169fa4aa62)
  * ну такое себе...
  * Отчет по сканированию: 
  
</details>

## Задача 3

<details>
  <summary>Условия</summary>
  
  1. Изучите файл "proxy.yaml"
  2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
  3. Опишите в файле ```compose.yaml``` следующие сервисы: 
    
  - ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
  Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 
    
  - ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!
  4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете ```None``` --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.
  5. Подключитесь к БД mysql с помощью команды ```docker exec <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.  
  6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.
   
</details>

<details>
    <summary>Решение</summary>
    
</details>

## Задача 4
<details>
    <summary>Условия</summary>
  
    1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
    2. Подключитесь к Вм по ssh и установите docker.
    3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
    4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy.
    5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
    6. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.
</details>
  
<details>
    <summary>Решение</summary>
    
</details>

## Задача 5 (*)
<details>
    <summary>Условия</summary>
  
    1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
    2. Протестируйте ручной запуск
    3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
    4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"
    
</details>

<details>
    <summary>Решение</summary>
    
</details>

## Задача 6 (*)
<details>
    <summary>Условия</summary>
  
    Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
    Предоставьте скриншоты  действий.
  
</details>

<details>
    <summary>Решение</summary>
    
</details>

## Задача 6.1
<details>
    <summary>Условия</summary>
  
    Добейтесь аналогичного результата, используя docker cp.  
    Предоставьте скриншоты  действий .
    
</details>

<details>
    <summary>Решение</summary>
    
</details>

## Задача 6.2 (**)
<details>
    <summary>Условия</summary>
  
    Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.
    Предоставьте скриншоты  действий.
  
</details>

<details>
    <summary>Решение</summary>
    
</details>

## Задача 7 (***)

<details>
    <summary>Условия</summary>
  
    Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
    Предоставьте скриншоты  действий .
</details>

<details>
    <summary>Решение</summary>
    
</details>
