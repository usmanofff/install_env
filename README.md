# install_env

СПРИНТ- 1

```
ЗАДАЧА

Опишите инфраструктуру будущего проекта в виде кода с инструкциями по развертке, нужен кластер Kubernetes и служебный сервер (будем называть его srv).

1 Выбираем облачный провайдер и инфраструктуру.

В качестве облака подойдет и Яндекс.Облако, но можно использовать любое другое по желанию.

Нам нужно три сервера:

два сервера в одном кластере Kubernetes: 1 master и 1 app;
сервер srv для инструментов мониторинга, логгирования и сборок контейнеров.
2 Описываем инфраструктуру.

Описывать инфраструктуру мы будем, конечно, в Terraform.

Совет: лучше создать под наши конфигурации отдельную группу проектов в Git, например, devops.
Пишем в README.md инструкцию по развертке конфигураций в облаке. Никаких секретов в коде быть не должно.

3 Автоматизируем установку.
```
 - Выбрираем провайдера для будующей инфраструктуры
 - Описываем необходимую конфигурацию в terraform
 - Подготавливаем необходимое окружение
 - Автоматизируем установку

В качествет провайдера был выбран Yandex. Начала работы с yandex и terraform можно найти по ссылке   ``` https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart ```

Создаем Конфигурацию terraform : 
  - сервисный аккаунт для управление инфраструктурой terraform
  - сервер Ubuntu 22.04 LTS

Передаем на сервер: 
  - приватные данные yandex_token, yc_cloud_id, yc_folder_id
  - ключи авторизации SSH
  - terraform
  - .terraformrc для подключения к yandex облаку
  -  config ssh
  -  script для установки по
    
Устанавливаем ПО на сервер:  
  - TERRAFORM
  - GIT
  - DOCKER
  - DOCKER COMPOSE
  - PIP
  - ANSIBLE
  - KUBECTL
  - GITLUB-RUNNER
  - HELM
  - JQ

Также необходимо установить зависимости KUBESPRAY из файла requirements.txt

Настраиваем разрешения и копируем данные по папкам.

Клонируем на сервер репозитории для развертывание kubespray.    ``` git@github.com:usmanofff/kubespray_setup.git ``` 

Так же необходимо форкнуть kubespray и склонировать на сервер    ``` git@github.com:usmanofff/kubespray.git ```

В процессе развертывания конфигурации сервера , выполняется скрипт с установкой по и необходимого окружения.

Разворачиваем конфигурацию с помощью команды: 
```
terraform apply -auto-approve
```

![wm_yandex](https://github.com/usmanofff/install_env/assets/74288450/80dca3e7-bd97-42ee-a0c1-223beb2dbf7c)


