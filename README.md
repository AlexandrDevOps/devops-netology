# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"  
1.  Создан unit-файл для node_exporter и помещен по следующему пути: /lib/systemd/system:
  
      [Unit]
      Description=Node Exporter
      After=network.target
      [Service]
      EnvironmentFile=-/home/vagrant/node_exporter/options
      ExecStart=/home/vagrant/node_exporter/node_exporter $OPTS
      Restart=on-failure
      Type=simple
      [Install]
      WantedBy=multi-user.target

      Далее требуется создать файл, в котором можно будет указывать опции при запуске node_exporter:

      vagrant@vagrant:~$ cat node_exporter/options  
            OPTS="--collector.cpu.info"  

      Добавим в автозапуск:  
      
      vagrant@vagrant:~$ sudo -i  
      root@vagrant:/lib/systemd/system# systemctl enable node_exporter.service  

      перезапускаем systemd для применения настроек:  

      root@vagrant:/lib/systemd/system# systemctl daemon-reload  

      Запускаем службу и проверяем статус:  

      root@vagrant:/lib/systemd/system# service node_exporter start  
      root@vagrant:/lib/systemd/system# service node_exporter status  
      ● node_exporter.service - Node Exporter  
      Loaded: loaded (/lib/systemd/system/node_exporter.service; enabled; vendor preset: enabled)  
      Active: active (running) since Sat 2022-01-01 23:34:12 UTC; 19s ago  
      Main PID: 18859 (node_exporter)  
            Tasks: 6 (limit: 2278)  
            Memory: 2.7M  
            CGroup: /system.slice/node_exporter.service  
                        └─18859 /home/vagrant/node_exporter/node_exporter --collector.cpu.info  

      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=thermal_zone  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=time  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=timex  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=udp_queues  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=uname  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=vmstat  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=xfs  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.726Z caller=node_exporter.go:115 level=info collector=zfs  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.727Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9>  
      Jan 01 23:34:12 vagrant node_exporter[18859]: ts=2022-01-01T23:34:12.729Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=fal>  

      Проверяем, что служба работает:  

      vagrant@vagrant:~$ curl -s http://localhost:9100/metrics 2>/dev/null | grep node_filesystem_avail_bytes | grep mapper  
      node_filesystem_avail_bytes{device="/dev/mapper/vgvagrant-root",fstype="ext4",mountpoint="/"} 6.055673856e+10  

      Работа сервиса корректна и в дальнейшем после перезагрузки будет производится без проблем.  
2.  Для мониторинга CPU:   
      node_cpu_seconds_total{cpu="0",mode="idle"} 2238.49  
      node_cpu_seconds_total{cpu="0",mode="system"} 16.72  
      node_cpu_seconds_total{cpu="0",mode="user"} 6.86  
      process_cpu_seconds_total  
    Для мониторинга Memory:  
      node_memory_MemAvailable_bytes   
      node_memory_MemFree_bytes  
    Для мониторинга Disk:  
      node_disk_io_time_seconds_total{device="sda"}   
      node_disk_read_bytes_total{device="sda"}   
      node_disk_read_time_seconds_total{device="sda"}   
      node_disk_write_time_seconds_total{device="sda"}  
    Для мониторинга Network(так же для каждого активного адаптера):  
      node_network_receive_errs_total{device="eth0"}   
      node_network_receive_bytes_total{device="eth0"}   
      node_network_transmit_bytes_total{device="eth0"}  
      node_network_transmit_errs_total{device="eth0"}  
3.    Результат выполнения приложен в виде документа со скрином. В документе дополнительно поясняется как удалось запустить.        
4.    Согласно выводу, да полностью осознает 
    
      vagrant@vagrant:~$ dmesg |grep virtualiz  
      [    0.011529] CPU MTRRs all blank - virtualized system.  
      [    0.222665] Booting paravirtualized kernel on KVM  
      [    3.969612] systemd[1]: Detected virtualization oracle. 
      
5.    Максимальное число открытых дескрипторов для ядра (системы), для пользователя задать больше без изменения числа не получится Задавать необходимо кратно 1024.
       
      vagrant@vagrant:~$ /sbin/sysctl -n fs.nr_open    
      1048576    
      Максимальное число операционной системы: 
      vagrant@vagrant:~$ cat /proc/sys/fs/file-max  
      9223372036854775807 
      
6.    vagrant@vagrant:~$ su  
      Password:  
      root@vagrant:/home/vagrant# unshare --pid --fork --mount-proc sleep 1h &  
      [1] 1271  
      root@vagrant:/home/vagrant# lsns  
        NS TYPE   NPROCS   PID USER            COMMAND  
      4026531835 cgroup     99     1 root            /sbin/init  
      4026531836 pid        96     1 root            /sbin/init  
      4026531837 user       99     1 root            /sbin/init  
      4026531838 uts        97     1 root            /sbin/init  
      4026531839 ipc        99     1 root            /sbin/init  
      4026531840 mnt        86     1 root            /sbin/init  
      4026531860 mnt         1    15 root            kdevtmpfs  
      4026531992 net        99     1 root            /sbin/init  
      4026532162 mnt         1   388 root            /lib/systemd/systemd-udevd  
      4026532163 uts         1   388 root            /lib/systemd/systemd-udevd  
      4026532164 mnt         1   393 systemd-network /lib/systemd/systemd-networkd  
      4026532183 mnt         1   558 systemd-resolve /lib/systemd/systemd-resolved  
      4026532184 uts         1   610 root            /lib/systemd/systemd-logind  
      4026532185 mnt         2   670 _lldpd          lldpd: monitor.  
      4026532186 mnt         2  1234 root            unshare --pid --fork --mount-proc sleep 1h  
      4026532187 pid         1  1235 root            sleep 1h  
      4026532188 mnt         2  1237 root            unshare --pid --fork --mount-proc sleep 1h  
      4026532189 pid         1  1238 root            sleep 1h  
      4026532190 mnt         2  1271 root            unshare --pid --fork --mount-proc sleep 1h  
      4026532191 pid         1  1272 root            sleep 1h  
      4026532249 mnt         1   610 root            /lib/systemd/systemd-logind  
      root@vagrant:/home/vagrant# nsenter -a -t 1271  
      root@vagrant:/# ps  
      Error, do this: mount -t proc proc /proc  
      root@vagrant:/# mount -t proc proc /proc  
      root@vagrant:/# ps  
            PID TTY          TIME CMD  
           1263 pts/0    00:00:00 su  
           1264 pts/0    00:00:00 bash  
           1271 pts/0    00:00:00 unshare  
           1272 pts/0    00:00:00 sleep  
           1276 pts/0    00:00:00 nsenter  
           1277 pts/0    00:00:00 bash  
           1289 pts/0    00:00:00 ps  
           
7.    Команда :(){ :|:& };: - это вредоносная команда (fork-Бомба), в результате которой запускается функция, которая запускает два своих экземпляра, которые в свою         очередь запускают еще по два, потребляя ресурсы системы. Таким образом, будут создаваться новые процессы до исчерпания лимитов.  
      Вывод dmesg показал, что сработали лимиты системы cgroups на уровне user.slice.  
      Текущий лимит на максимальное число запущенных процессов для пользователя, который вошел в систему, можно посмотреть командой (стоит limit: 5014)
      
          vagrant@vagrant:~$ systemctl status user-1000.slice  
          ● user-1000.slice - User Slice of UID 1000  
            Loaded: loaded  
            Drop-In: /usr/lib/systemd/system/user-.slice.d  
                         └─10-defaults.conf  
            Active: active since Sat 2022-01-01 19:57:16 UTC; 1min 6s ago   
            Docs: man:user@.service(5)  
            Tasks: 7 (limit: 5014)  
            Memory: 6.5M  
            CGroup: /user.slice/user-1000.slice  
                        ├─session-1.scope  
                        │ ├─734 sshd: vagrant [priv]  
                        │ ├─766 sshd: vagrant@pts/0  
                        │ ├─767 -bash  
                        │ ├─870 systemctl status user-1000.slice  
                        │ └─871 pager  
                        └─user@1000.service  
                           └─init.scope  
                             ├─737 /lib/systemd/systemd --user  
                             └─738 (sd-pam)  

            Jan 01 19:57:17 vagrant systemd[737]: Listening on GnuPG cryptographic agent and passphrase cache (restricted).  
            Jan 01 19:57:17 vagrant systemd[737]: Listening on GnuPG cryptographic agent (ssh-agent emulation).  
            Jan 01 19:57:17 vagrant systemd[737]: Listening on GnuPG cryptographic agent and passphrase cache.  
            Jan 01 19:57:17 vagrant systemd[737]: Listening on debconf communication socket.  
            Jan 01 19:57:17 vagrant systemd[737]: Listening on REST API socket for snapd user session agent.  
            Jan 01 19:57:17 vagrant systemd[737]: Listening on D-Bus User Message Bus Socket.  
            Jan 01 19:57:17 vagrant systemd[737]: Reached target Sockets.  
            Jan 01 19:57:17 vagrant systemd[737]: Reached target Basic System.  
            Jan 01 19:57:17 vagrant systemd[737]: Reached target Main User Target.  
            Jan 01 19:57:17 vagrant systemd[737]: Startup finished in 705ms.  
        Проверить данный лимит можно с помощью команды: systemctl cat user-1000.slice  
        Допустимо изменить лимит:
        
        vagrant@vagrant:~$ sudo cat /usr/lib/systemd/system/user-1000.slice.d/10-tasksmax.conf  
        [Slice]  
        TasksMax=100 
        
        после требуется перезапустить systemd для применения настроек.  
