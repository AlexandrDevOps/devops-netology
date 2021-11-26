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
     
 10. /proc/<PID>/cmdline - полный путь до исполняемого файла процесса [PID]  (строка 231)
     /proc/<PID>/exe - содержит ссылку до файла запущенного для процесса [PID], 
                        cat выведет содержимое запущенного файла, 
                        запуск этого файла,  запустит еще одну копию самого файла  (строка 285)
 11. Cat или Less /proc/cpuinfo в разделе 'flags':
      процессор Intel core i5 2430m наиболее старшая инструкция sse4.2.
      
 12. При подключении ожидается пользователь, а не другой процесс, и отсутствует локальный tty.
    vagrant@vagrant:~$ ssh localhost 'tty'
    vagrant@localhost's password:
 13. Предварительно был установлен пакет reptyr sudo apt-get install reptyr
      vagrant@vagrant:~$ pstree -p
            systemd(1)─┬─VBoxService(812)─┬─{VBoxService}(813)
                   │                  ├─{VBoxService}(814)
                   │                  ├─{VBoxService}(815)
                   │                  ├─{VBoxService}(816)
                   │                  ├─{VBoxService}(817)
                   │                  ├─{VBoxService}(818)
                   │                  ├─{VBoxService}(819)
                   │                  └─{VBoxService}(820)
                   ├─accounts-daemon(581)─┬─{accounts-daemon}(591)
                   │                      └─{accounts-daemon}(628)
                   ├─agetty(690)
                   ├─atd(680)
                   ├─cron(677)
                   ├─dbus-daemon(587)
                   ├─lldpd(666)───lldpd(692)
                   ├─multipathd(524)─┬─{multipathd}(525)
                   │                 ├─{multipathd}(526)
                   │                 ├─{multipathd}(527)
                   │                 ├─{multipathd}(528)
                   │                 ├─{multipathd}(529)
                   │                 └─{multipathd}(530)
                   ├─networkd-dispat(605)
                   ├─polkitd(642)─┬─{polkitd}(644)
                   │              └─{polkitd}(646)
                   ├─rpcbind(555)
                   ├─rsyslogd(607)─┬─{rsyslogd}(618)
                   │               ├─{rsyslogd}(619)
                   │               └─{rsyslogd}(620)
                   ├─sshd(679)───sshd(822)───sshd(858)───bash(859)─┬─less(888)
                   │                                               └─pstree(890)
                   ├─systemd(828)───(sd-pam)(830)
                   ├─systemd-journal(359)
                   ├─systemd-logind(609)
                   ├─systemd-network(385)
                   ├─systemd-resolve(556)
                   └─systemd-udevd(384)
vagrant@vagrant:~$ bg less
[1]+ less /proc/cpuinfo &

[1]+  Stopped                 less /proc/cpuinfo
vagrant@vagrant:~$ sudo sh -c reptyr 888
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
stepping        : 7
cpu MHz         : 2394.562
cache size      : 3072 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 x2apic popcnt aes xsave avx hypervisor lahf_lm pti md_clear flush_l1d
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs itlb_multihit
bogomips        : 4789.12
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
      
     Командой bg возобновляет процесс в фоновом режиме.
      
 14.  команда tee делает вывод одновременно и в файл, указаный в качестве параметра, и в stdout, 
      в данном примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo
      и так как команда запущена от sudo , соотвественно имеет права на запись в файл
