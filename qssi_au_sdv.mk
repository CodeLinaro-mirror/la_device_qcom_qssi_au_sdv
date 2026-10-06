TARGET_SDV_ENABLED := true

SDV_SOMEIP_BROKER_CONFIG := broker_config.json
PRODUCT_SYSTEM_PROPERTIES += ro.sdv.someip.broker_config=/system/etc/someip/broker_config.json
SDV_VM_LEVEL_PERMISSIONS_MODULE := com.oem.sdv.authz.allow_all.core

SDV_OPEN_DICE_PROVIDER_PACKAGES := \
                            init_open_dice_from_file \
                            sample_dice_handover_file

BOARD_ROOT_EXTRA_FOLDERS += vvmtruststore

SDV_VEHICLE_POWER_STATE_MANAGER_MODULE := vepsm

SDV_DIAGNOSTICS_AGENT_MODULE := sdv_diagnostics_agent

PRODUCT_COPY_FILES += device/google/sdv/sdv_cf/ethernet/ethernet.sdv_cf.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/hw/ethernet.sdv_cf.rc
include device/google/sdv/sdv_core_base/sdv_core_base.mk
PRODUCT_COPY_FILES += \
    device/google/sdv/sdv_core_arm64/init.sdv_core_arm64.rc:system/etc/init/hw/init.sdv.rc \
    device/google/sdv/sdv_core_arm64/ethernet/ethernet.sdv_arm64.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/hw/ethernet.sdv_arm64.rc \
    device/google/sdv/sdv_core_arm64/ethernet/ethernet.sdv_arm64.sh:$(TARGET_COPY_OUT_PRODUCT)/bin/ethernet/ethernet.sdv_arm64.sh

# Include SDV sample makefiles only for non-production (userdebug/eng) builds.
# These samples should NOT be included in user (production) builds.
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
include device/google/sdv/sdv_base/sdv_sample_ethernet_setup.mk
include device/google/sdv/sdv_base/sdv_samples_base_services.mk
include device/google/sdv/sdv_core_base/sdv_samples_all.mk
endif

# Inlined from device/qcom/qssi_au/qssi_au.mk
#For QSSI, we build only the system image. Here we explicitly set the images
#we build so there is no confusion.

TARGET_BOARD_PLATFORM := qssi
TARGET_BOOTLOADER_BOARD_NAME := qssi_au_sdv

# Scalable UI (DEWD) enable flag. Set to false to disable all Scalable UI changes.
TARGET_SCALABLE_UI_ENABLE ?= false
TARGET_BOARD_TYPE := auto
TARGET_BOARD_SUFFIX := _au_sdv

TARGET_BOARD_AUTO := true
TARGET_NO_TELEPHONY := true

$(call inherit-product, device/qcom/qssi_au_sdv/base.mk)

# For PRODUCT_COPY_FILES, the first instance takes precedence.
# # Since we want use QC specific files, we should inherit
# # device-vendor.mk first to make sure QC specific files gets installed.

$(call inherit-product-if-exists, $(QCPATH)/common/config/device-vendor-qssi.mk)


#DEVICE_SUPPORTS_64_BIT_APPS_ONLY := true
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Skip VINTF checks for kernel configs since we do not have kernel source
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

RELAX_USES_LIBRARY_CHECK := true

#Enable product partition Java I/F. It is automatically set to true if
#the shipping API level for the target is greater than 29
PRODUCT_ENFORCE_PRODUCT_PARTITION_INTERFACE := true

PRODUCT_BUILD_SYSTEM_IMAGE := true
PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
PRODUCT_BUILD_VENDOR_IMAGE := false
# Vendor boot image is not needed in a QSSI-only system build.
# Setting this to false prevents BUILDING_VENDOR_BOOT_IMAGE from being set to
# true (even though BOARD_BOOT_HEADER_VERSION=4), which avoids the
# ES_SYSTEM_DEPS dependency on the 32-bit linker that conflicts with
# core_64_bit_only.mk (TARGET_SUPPORTS_32_BIT_APPS := false).
PRODUCT_BUILD_VENDOR_BOOT_IMAGE := false
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
PRODUCT_BUILD_ODM_IMAGE := false
PRODUCT_BUILD_CACHE_IMAGE := false
PRODUCT_BUILD_USERDATA_IMAGE := false

# Enable debugfs restrictions
PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

#Also, there is no need to build an OTA package as this will be done later
#when we combine this system build with the non-system images.
TARGET_SKIP_OTA_PACKAGE := true
# Enable AVB 2.0
BOARD_AVB_ENABLE := true

BOARD_HAVE_QCOM_FM := false

SHIPPING_API_LEVEL := 37

#### Turning BOARD_DYNAMIC_PARTITION_ENABLE flag to TRUE will enable dynamic partition/super image creation.
BOARD_DYNAMIC_PARTITION_ENABLE ?= true
PRODUCT_SHIPPING_API_LEVEL := $(SHIPPING_API_LEVEL)

ifneq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
# Enable chain partition for system, to facilitate system-only OTA in Treble.
BOARD_AVB_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_SYSTEM_ROLLBACK_INDEX := 0
BOARD_AVB_SYSTEM_ROLLBACK_INDEX_LOCATION := 2
PRODUCT_BUILD_RAMDISK_IMAGE := false
PRODUCT_BUILD_PRODUCT_IMAGE := false
else
PRODUCT_USE_DYNAMIC_PARTITIONS := true
# Disable building the SUPER partition in this build. SUPER should be built
# after QSSI has been merged with the SoC build.
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := true
PRODUCT_BUILD_PRODUCT_IMAGE := true
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_BUILD_RAMDISK_IMAGE := true
endif
#### Dynamic Partition Handling

PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.enable_rkpd=true \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com \

PRODUCT_SOONG_NAMESPACES += \
    frameworks/base/boot \
    cts/tests/signature/api-check \
    hardware/google/av \
    hardware/google/interfaces

VENDOR_QTI_PLATFORM := qssi_au_sdv
VENDOR_QTI_DEVICE := qssi_au_sdv

#QSSI configuration
#Single system image project structure
TARGET_USES_QSSI := true

TARGET_USES_NEW_ION := true

ENABLE_AB ?= true

PRODUCT_NAME := $(VENDOR_QTI_DEVICE)
PRODUCT_DEVICE := $(VENDOR_QTI_DEVICE)
PRODUCT_BRAND := qti
PRODUCT_MODEL := qssi system image for arm64

#Initial bringup flags
TARGET_USES_AOSP := false
TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_USES_QCOM_BSP := false

# RRO configuration
TARGET_USES_RRO := true


# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard
BOARD_FRP_PARTITION_NAME := frp

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES_DEBUG += avbctl

ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_BOOT_JARS += telephony-ext
PRODUCT_PACKAGES += telephony-ext
endif

TARGET_ENABLE_QC_AV_ENHANCEMENTS := false

TARGET_DISABLE_DASH := true
TARGET_DISABLE_QTI_VPP := true

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk
-include $(TOPDIR)vendor/qcom/opensource/commonsys/audio/configs/qssi/qssi.mk
AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE := true
USE_LIB_PROCESS_GROUP := true

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    bootctrl.msmnile \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

#Healthd packages
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-convert \
    android.hardware.health@1.0-service \
    libhealthd.msm

DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/qssi_au_sdv/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml

PRODUCT_PRODUCT_PROPERTIES += persist.adb.tcp.port=5555

#audio related module
PRODUCT_PACKAGES += libvolumelistener

# Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service_64

# Ethernet configuration file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Context hub HAL
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic \
    android.hardware.contexthub@1.0-service


PRODUCT_SYSTEM_PROPERTIES += ro.android.car.audio.enableaudiopatch=true


# Disable RTT (Real-Time Text) feature
PRODUCT_SYSTEM_PROPERTIES += config.disable_rtt=true

# Enable WFD debug property
PRODUCT_SYSTEM_PROPERTIES += persist.debug.wfd.enable=1

# USB default HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

#PASR HAL and APP
PRODUCT_PACKAGES += \
    vendor.qti.power.pasrmanager@1.0-service \
    vendor.qti.power.pasrmanager@1.0-impl \
    pasrservice

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service

TARGET_MOUNT_POINTS_SYMLINKS := false

TARGET_USES_MKE2FS := true

PRODUCT_PROPERTY_OVERRIDES += \
ro.crypto.volume.filenames_mode = "aes-256-cts" \
ro.crypto.allow_encrypt_override = true

TARGET_USES_QCOM_DISPLAY_BSP := true

ifeq ($(TARGET_USES_NEW_ION),true)
AUDIO_FEATURE_ENABLED_DLKM := true
else
AUDIO_FEATURE_ENABLED_DLKM := false
endif

$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Include mainline components and QSSI whitelist
ifeq (true,$(call math_gt_or_eq,$(SHIPPING_API_LEVEL),29))
  #$(call inherit-product, device/qcom/qssi_au/qssi_au_whitelist.mk)
  #PRODUCT_ARTIFACT_PATH_REQUIREMENT_IGNORE_PATHS := /system/system_ext/
  PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := false
endif

PRODUCT_PACKAGES += vendor.qti.qesdsys

#Add soong variable to enable gpp extension!
$(call add_soong_config_var,video_extensions,enable_gpp_extensions)
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
$(call soong_config_set,video_extensions,enable_gpp_extensions,true)
endif

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

###################################################################################
# Pickup other split product.mk files (audio_system_product.mk, display,
# # bluetooth, gps, cne, securemsm, etc.).
# # Previously pulled in via device/qcom/qssi_au; added back explicitly since
# # qssi_au_sdv is now standalone.
# ###################################################################################
# Selective includes from vendor/qcom/defs/product-defs/system/ — only the files
# that provide the modules needed by qssi_au_sdv (RBVM). The wildcard *.mk is NOT
# used because bt-system-opensource-product.mk (PRODUCT_BOOT_JARS += qcom.fmradio)
# and perf-core-product-system.mk (PRODUCT_BOOT_JARS += QPerformance) add boot jars
# absent from the compiled code, causing the hidden API flags generation to fail.
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/adreno-product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/app_noship_product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/audio_system_product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/display-product-commonsys.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/display-product-system-proprietary.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/gp_system_proprietary_product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/mm-parser-product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/qseecom_lib_system_product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/securemsm_product.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/smcinvoke_system_product.mk)
# ###################################################################################

# Enable Car Telemetry
ENABLE_CARTELEMETRY_SERVICE := true
PRODUCT_PACKAGES += android.automotive.telemetryd@1.0


DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/qcom/qssi_au_sdv/compatibility_matrix.xml

# sdv_core_base adds update_engine_nonetd as the drop-in replacement for devices
# without netd. Remove the standard update_engine to avoid a duplicate service
# name ('update_engine') that causes host_init_verifier to fail.
PRODUCT_PACKAGES := $(filter-out update_engine,$(PRODUCT_PACKAGES))

PRODUCT_PACKAGES += \
    com.sdv.google.display_safety.services_bundle.apex

# Add tools/utils
PRODUCT_PACKAGES += \
    harry_rpc_client

# QSSI standalone no longer inherits base_system.mk (previously pulled in
# transitively via device/qcom/qssi_au/qssi_au.mk). Without this package the
# system image is missing /system/bin/sh, toybox and /system/etc/mkshrc, so
# 'adb shell' lands on a bare "$" with no PATH tools.
PRODUCT_PACKAGES += shell_and_utilities_system

# When QSSI's standalone /system and /product are merged over a vendor
# build (e.g. gen4_gvm_sdv), Android init resolves the unqualified
# ro.product.{brand,device,manufacturer,model,name} by walking
# ro.product.property_source_order. The AOSP default order is
# "product,odm,vendor,system_ext,system" (see
# system/core/init/property_service.cpp), which makes QSSI's own
# ro.product.product.device=qssi_au_sdv win over the vendor's
# ro.product.vendor.device=gen4_gvm_sdv. That causes adb shell / HOSTNAME
# / getprop ro.product.device to report the QSSI blueprint name instead
# of the physical vendor target. Put vendor first so the vendor-owned
# board identity wins on merged flashes, while a true QSSI-only boot
# (no /vendor present) still correctly falls through to qssi_au_sdv.
# This was getting updated earlier by device/qcom/qssi_au/system.prop file

PRODUCT_SYSTEM_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

TARGET_FS_CONFIG_GEN += device/google/sdv/sdv_core_base/config.fs

PRODUCT_PACKAGES += \
    dice_handover_instance1 \
    dice_handover_instance2 \
    dice_handover_instance3

PRODUCT_COPY_FILES += device/google/sdv/sdv_base/vvmtruststore/vvmtruststore.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/vvmtruststore.rc

PRODUCT_PACKAGES += \
    android.sdv.hardware.security.keymint-service.nonsecure

PRODUCT_PROPERTY_OVERRIDES  += \
     ro.boot.sdv.instance_name=instance1 \
     ro.boot.sdv.boot_mode=unlocked

PRODUCT_PACKAGES += android.hidl.allocator@1.0-service

PRODUCT_PROPERTY_OVERRIDES += hwservicemanager.disabled=1

PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.sdv.vvmfactorytrust=c779a73d0595a6814ba0414a419e99ad4026ad0feb603f2ad80ee6a9e4d1adb7 \
    ro.sdv.ethernet.ready=true

PRODUCT_PACKAGES += init_open_dice

include device/google/sdv/sdv_base/sepolicy/samples/device_sepolicy.mk

# Filter out UI packages that are added unconditionally by makefiles included
# via device-vendor-qssi.mk or audio configs, which cannot be individually guarded:
#   - FrameworksResAutoCommon_Sys, SystemUIResAutoCommon_Sys, WifiResAutoCommon_Sys,
#     DewdSplitViewQcomRRO, DewdThreePanelQcomRRO: automotive resource overlays from
#     commonsys/resource-overlay/overlay.mk (included when TARGET_BOARD_AUTO=true)
#   - AudioSettings: audio settings UI app added to PRODUCT_PACKAGES_DEBUG via
#     commonsys/audio/configs/qssi/qssi.mk
#

PRODUCT_PACKAGES := $(filter-out \
    FrameworksResAutoCommon_Sys \
    SystemUIResAutoCommon_Sys \
    WifiResAutoCommon_Sys \
    DewdSplitViewQcomRRO \
    DewdThreePanelQcomRRO \
    ,$(PRODUCT_PACKAGES))
PRODUCT_PACKAGES_DEBUG := $(filter-out AudioSettings,$(PRODUCT_PACKAGES_DEBUG))

