{
  configurations.nixos.iso.module =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # disk recovery
        testdisk
        safecopy
        parted
        tparted
        wiper
        fsarchiver
        partclone
        ddrescue
        ddrutility
        testdisk-qt

        # cpu
        stress
        stress-ng
        stressapptest

        # memory
        memtester

        # misc hardware
        dmidecode
        read-edid
        edid-decode
        edid-generator
        rwedid
        fanctl
        fan2go
        i2c-tools
        hwinfo
        lm_sensors
        lshw
        smartmontools
        usbutils

        # encryption
        cryptsetup
        gnupg
        age

        # filesystem maintenance
        gptfdisk

        # filesystem support
        go-mtpfs
        exfatprogs
        f2fs-tools
        mtools
        simple-mtpfs
        sshfs
        ntfs3g
        e2fsprogs
        xfsprogs
        btrfs-progs

        # specific filesystem recovery tools
        ext4magic
        myrescue
        safecopy
        extundelete
        xfs-undelete
        fatcat
        ntfs2btrfs

        # boot loader access
        grub2
        efibootmgr

        # network tools
        iproute2
        tcpdump
        netcat-gnu

        # miscellaneous tools
        util-linux
        sleuthkit
        coreutils-full

        # windows tooling
        rdesktop
        chntpw
        samba4Full

        # file archive & compression tools
        gnutar
        gzip
        xz
        zstd
        lz4
        bzip2
        zip
        p7zip

        # ISO utils
        cdrtools

        # Hex editors
        hexedit
      ];
    };
}
