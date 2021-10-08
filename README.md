# deploy-vm-kvm-terraform
Этот проект посвящен деплою виртуальных машин через libvirt плагин terraform, с использованием статической ip адресации внутри kvm( организовано на базе связи уникального mac адреса и присваемаемого ему ip) посмотреть текущий конфиг сети default в kvm можно **virsh net-edit default**
## Предварительная подготовка образа для комфортной работы
Добавим env переменные
```
export default_pool_images=$(echo $(virsh pool-dumpxml default|grep -oP '(?<path>)(/.*?)(?=</path>)'))
export terraform_image=terra-centos7.qcow2
echo $default_pool_images/$terraform_image
```
Подготавливаем образ -который будем использовать как базовый при развертываниях в terraform. Сначала его необходимо скачать в storage pool вашего гипервизора - можно это сделать такой командой:
```
wget -c http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O $default_pool_images/$terraform_image
```
Сменим пароль от пользователя root ( что бы команда virt-sysprep работала  нужно что бы в нутри образа был установлен qemu-guest-agent )
```
sudo virt-sysprep -a $default_pool_images/$terraform_image --root-password password:ВАШ_ПАРОЛЬ
```
Посмотрим его обьем до 40 гигов
```
qemu-img info $default_pool_images/$terraform_image
```
Увеличим его обьем
```
qemu-img resize $default_pool_images/$terraform_image +32G
```
И увеличим размер диска внутри виртуального диска Внимание для выполнения этих команд в вашем образе должны  быть утилиты **qemu-guest-agent, growpart, xfs_growfs а так же файловая система корня должна быть xfs **
```
sudo virt-sysprep -a $default_pool_images/$terraform_image --run-command 'mount /dev/sda1 /; growpart /dev/sda 1; xfs_growfs / -d'
```

## Как использовать
Сначала копируем terraform.tfvars и изменим его
```
cp terraform.tfvars.simple terraform.tfvars
vi terraform.tfvars
```
Запустить деплой виртуалок
```
terraform init
terraform plan
terraform apply
```

## Полезные ссылки:
- Используемый терраформ провайдер - https://github.com/dmacvicar/terraform-provider-libvirt
- Изменение размера через growpart https://serveradmin.ru/rasshirenie-uvelichenie-xfs-kornevogo-razdela-bez-ostanovki/
- Установка qemu агента https://timeweb.com/ru/help/pages/viewpage.action?pageId=27918911
