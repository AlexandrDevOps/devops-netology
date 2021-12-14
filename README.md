# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"  
1. Системный вызов команды CD это chdir("/tmp") в нашем случае.  
2. При использовании strace для команды file выявил закономерность и согласно логу база находится /usr/share/misc/magic.mgc:  
      openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3  
   Данная строка присутсвтует во всех запросах по дирректориям указаным в задании.  
3.    root@vagrant:~# ping 192.168.0.1>log &  
      [1] 1355  
      root@vagrant:~# lsof -p 1355  
      COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME  
      ping    1355 root  cwd    DIR  253,0     4096 3538945 /root  
      ping    1355 root  rtd    DIR  253,0     4096       2 /  
      ping    1355 root  txt    REG  253,0    72776  524524 /usr/bin/ping  
      ping    1355 root  mem    REG  253,0  5699248  535133 /usr/lib/locale/locale-archive  
      ping    1355 root  mem    REG  253,0   137584  527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0  
      ping    1355 root  mem    REG  253,0  2029224  527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so  
      ping    1355 root  mem    REG  253,0   101320  527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so  
      ping    1355 root  mem    REG  253,0  1168056  527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5  
      ping    1355 root  mem    REG  253,0    31120  527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32  
      ping    1355 root  mem    REG  253,0   191472  527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so  
      ping    1355 root    0u   CHR  136,0      0t0       3 /dev/pts/0  
      ping    1355 root    1w   REG  253,0        0 3538952 /root/log  
      ping    1355 root    2u   CHR  136,0      0t0       3 /dev/pts/0  
      ping    1355 root    3u  icmp             0t0   29719 00000000:0004->00000000:0000  
      ping    1355 root    4u  sock    0,9      0t0   29720 protocol: PINGv6  
      root@vagrant:~# lsof -p 1355 | grep log  
      ping    1355 root    1w   REG  253,0        0 3538952 /root/log  
      root@vagrant:~# rm -f log  
      root@vagrant:~# lsof -p 1355 | grep delete  
      ping    1355 root    1w   REG  253,0        0 3538952 /root/log (deleted)  
      root@vagrant:~# truncate -s0 /proc/1355/fd/1  
4. "Зомби" процессы освобождают ресурсы системы, но оставляют запись в таблице процессов. Запись освободиться при вызове wait() родительским процессом.   
5. После установки при вызове увидел обращения по следующему пути согласно логу:  
      vagrant@vagrant:~$ sudo -i  
      root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop  
      /usr/sbin/opensnoop-bpfcc  
      root@vagrant:~# /usr/sbin/opensnoop-bpfcc  
            PID    COMM               FD ERR PATH  
            1      systemd            12   0 /proc/385/cgroup  
            1      systemd            12   0 /proc/557/cgroup  
            938    vminfo              6   0 /var/run/utmp  
            593    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services  
            593    dbus-daemon        18   0 /usr/share/dbus-1/system-services  
            593    dbus-daemon        -1   2 /lib/dbus-1/system-services  
            593    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/  
  6. Команда Uname -a испорльзует системный вызов uname()  
      Цитата :  
                  Part of the utsname information is also accessible  via  /proc/sys/ker‐  
                  nel/{ostype, hostname, osrelease, version, domainname}.  
  7. && - условный оператор,  
      ; - разделитель последовательных команд  

      Например: echo 1 && echo 2 вернет 2 если первая команда выполнится успешно  
                echo 1 ; echo 2 выполнится второй командой по списку  
      есть еще вариант оператора || если echo 1 || echо 2 вернет 2 если первая команда выполнится неуспешно.  
      Команда считается успешной, если ее код выхода равен 0 и считается неудачно выполненной, если код выхода не равен 0  
  8.  set -euxo pipefail было бы хорошо использовать для сценариев чтобы повысить детализацию вывода ошибок и упрощения логирования.
      -e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности 
      -x вывод трейса простых команд 
      -u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова
      -o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.
  9.  Согласно man:
      S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения (спящие с прерыванием "сна")
      I*(I,I<) - фоновые(бездействующие) процессы ядра
      дополнительные символы это дополнительные характеристики, например приоритет.
