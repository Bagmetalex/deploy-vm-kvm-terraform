# deploy-vm-kvm-terraform
Этот проект посвящен деплою виртуальных машин через libvirt плагин terraform, с использованием статической ip адресации внутри kvm( организовано на базе связи уникального mac адреса и присваемаемого ему ip) посмотреть текущий конфиг сети default в kvm можно **virsh net-edit default**
# Предварительная подготовка образа для комфортной работы
Подготавливаем образ -который будем использовать как базовый при развертываниях в terraform
```
wget -c http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 -O terra-centos7.qcow2
```
Сменим пароль  от пользователя root ( что бы команда virt-sysprep работала  нужно что бы в нутри образа был установлен qemu-guest-agent )
```
sudo virt-sysprep -a "./terra-centos7.qcow2" --root-password password:ВАШ_ПАРОЛЬ
```
Посмотрим его обьем
```
qemu-img info ./terra-centos7.qcow2
```
Увеличим его обьем
```
qemu-img resize /home/vm/terra-centos7.qcow2 +32G
```
#и увеличим размер диска внутри виртуального диска (источник https://serveradmin.ru/rasshirenie-uvelichenie-xfs-kornevogo-razdela-bez-ostanovki/ )
```
virt-sysprep -a /home/vm/terra-centos7.qcow2 --run-command 'growpart /dev/sda 1 ; xfs_growfs / -d'
```

## Как использовать
```
Сначала копируем terraform.tfvars и изменим его
cp terraform.tfvars.simple terraform.tfvars
vi terraform.tfvars
```
Запустить деплой виртуалок
```
terraform init
terraform plan
terraform apply
```
