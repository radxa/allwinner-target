1.recovery系统使用swupdate_make_recovery_img -j32编译，分区表中打开recovery分区后打包。


2.打包recovery OTA升级包命令，根据sw-subimgs.cfg文件的后缀：

例：sw-subimgs-recovery.cfg使用的打包，命令为swupdate_pack_swu -recovery；

sw-subimgs-recovery-sign.cfg使用的打包，命令为swupdate_pack_swu -recovery-sign;

sw-subimgs-ab.cfg使用命令为swupdate_pack_swu -ab;

sw-subimgs-ab-rdiff.cfg使用命令为swupdate_pack_swu -ab-rdiff;


3.差分升级，以ab升级举例，menuconfig中选中rdiff选项。

分区表中存在bootA、bootB、rootfsA、rootfsB分区，设置相同downloadfile。

编译系统后使用swupdate_pack_swu -ab打包OTA包，在cout目录的swupdate目录下，将生成的OTA包xxx.swu，重新命名为base.swu

更改一些配置后，重新编译系统后使用swupdate_pack_swu -ab打包OTA包，在cout目录的swupdate目录下，将生成的OTA包xxx.swu，重新命名为new.swu

在当前目录下使用swupdate_make_delta base.swu new.swu生成差分包。

再使用swupdate_pack_swu -ab-rdiff，生成ab差分升级包，推入小机端执行升级命令即可。

注意buildroot的rootfs是可读写的，不做差分升级。


4.自适应nand/emmc升级，默认功能不开启，所以使用命令时，升级命令最后需加上_emmc、_ubinand 或 _rawnand，例：

emmc介质：recovery升级：swupdate_cmd.sh -i xxx.swu -e stable,upgrade_recovery_emmc。

rawnand介质：recovery升级：swupdate_cmd.sh -i xxx.swu -e stable,upgrade_recovery_rawnand。

ubinand介质：recovery升级：swupdate_cmd.sh -i xxx.swu -e stable,upgrade_recovery_ubinand。

如果需要开启自适应功能，需要在 openwrt/package/allwinner/system/swupdate/swupdate_cmd.sh 中将以下注释打开：

diff --git a/swupdate_cmd.sh b/swupdate_cmd.sh
index 6d12058..504e3f9 100755
--- a/swupdate_cmd.sh
+++ b/swupdate_cmd.sh
@@ -86,8 +86,8 @@ mkdir -p /var/lock
     echo "swu_software $swu_software" >> /tmp/swupdate_param_file
     swu_mode=$(echo "$swu_param_e" | awk -F ',' '{print $2}')
 #    echo "swu_mode: ##$swu_mode##"
-#    swu_mode=${swu_mode}_$(get_flash_type)
-#    echo "swu_mode after fix to emmc/nand: ##$swu_mode##"
+    swu_mode=${swu_mode}_$(get_flash_type)
+    echo "swu_mode after fix to emmc/nand: ##$swu_mode##"
     echo "swu_mode $swu_mode" >> /tmp/swupdate_param_file
     fw_setenv -s /tmp/swupdate_param_file
     sync


