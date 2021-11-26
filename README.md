#Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"  
1. Комманда cd это команда оболочки sh/bash. Не является отдельной программой или системным вызовом как другие, потому что, работать внутри сессии терминала проще и логичнее производить смену директории внутренней функцией. Если использовать внешний вызов, то он будет работать вне окружения и на вызовы оболочки не будет отвечать.
2. grep <some_string> <some_file> -c  согласно man grep.
3. Процесс с pid 1 на моей машине это systemd, он является родителем для всех остальных процессов. Команда: pstree -p результат выполнения на скрине.  
4. Команды в pts0:  
      vagrant@vagrant:~$ ls -l \root 2>/dev/pts/1  
      vagrant@vagrant:~$  
  Вывод в pts1:      
      vagrant@vagrant:~$ who  
      vagrant  pts/0        2021-11-26 12:58 (10.0.2.2)    
      vagrant  pts/1        2021-11-26 12:59 (10.0.2.2)   
      vagrant@vagrant:~$ ls: cannot access 'root': No such file or directory  
5. Одновременно выполнение возможно:  
    vagrant@vagrant:~$ cat>test_file_in    
      if [[ -d /tmp]];   
      123  
      321  
      456  
      654  
    vagrant@vagrant:~$ cat test_file_in  
      if [[ -d /tmp]];    
      123    
      321    
      456    
      654    
    vagrant@vagrant:~$ cat test_file_out    
      cat: test_file_out: No such file or directory    
    vagrant@vagrant:~$ cat <test_file_in>test_file_out    
    vagrant@vagrant:~$ cat test_file_out  
      if [[ -d /tmp]];  
      123  
      321  
      456  
      654  
    vagrant@vagrant:~$  
6. Вывести получится при использовании перенаправлении вывода:
    vagrant@vagrant:~$ tty
    /dev/pts/0
    vagrant@vagrant:~$ echo Hello from pts0 to tty1 >/dev/tty1
    vagrant@vagrant:~$

7. bash 5>&1 - Создаст дескриптор с 5 и перенатправит его в stdout   
    echo netology > /proc/$$/fd/5 - выведет в дескриптор "5", который был пернеаправлен в stdout    
      vagrant@vagrant:~$ echo netology > /proc/$$/fd/5  
      -bash: /proc/12637/fd/5: No such file or directory  
      vagrant@vagrant:~$ bash 5>&1  
      vagrant@vagrant:~$ echo netology > /proc/$$/fd/5  
      netology  
      vagrant@vagrant:~$  
 8. Получится если поменять стандартные потоки через промежуточный дескриптор
    vagrant@vagrant:~$ ls -l /root 9>&2 2>&1 1>&9 |grep denied -c 
    1

    9>&2 - новый дескриптор перенаправили в stderr
    2>&1 - stderr перенаправили в stdout 
    1>&9 - stdout - перенаправили в новый дескриптор
 9. Будут выведены переменные окружения (мой вывод):  
USER=vagrantLOGNAME=vagrantHOME=/home/vagrantPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:      /tmp/new_path_directory/bashSHELL=/bin/bashTERM=xterm-256colorXDG_SESSION_ID=7XDG_RUNTIME_DIR=/run/user/1000DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/busXDG_SESSION_TYPE=ttyXDG_SESSION_CLASS=userMOTD_SHOWN=pamLANG=en_US.UTF-8LANGUAGE=en_US:SSH_CLIENT=10.0.2.2 60402 22SSH_CONNECTION=10.0.2.2 60402 10.0.2.15 22SSH_TTY=/dev/
Если использовать команды  printenv и env то можно получить аналогичный вывод но с выводом построчно     
     
     
    
