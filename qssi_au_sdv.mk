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
-include device/google/sdv/sdv_core_base/sdv_core_arm64.mk
include device/google/sdv/sdv_base/sdv_sample_ethernet_setup.mk
#include device/google/sdv/sdv_base/vvmtruststore/vvmtruststore.mk
include device/google/sdv/sdv_base/sdv_samples_base_services.mk
include device/google/sdv/sdv_core_base/sdv_samples_all.mk
#include device/google/sdv/sdv_core_base/sdv_samples_core_services.mk
include device/qcom/qssi_au/qssi_au.mk

TARGET_BOARD_DERIVATIVE_SUFFIX := _sdv

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/qcom/qssi_au_sdv/compatibility_matrix.xml

# sdv_core_base adds update_engine_nonetd as the drop-in replacement for devices
# without netd. Remove the standard update_engine to avoid a duplicate service
# name ('update_engine') that causes host_init_verifier to fail.
PRODUCT_PACKAGES := $(filter-out update_engine,$(PRODUCT_PACKAGES))

VENDOR_QTI_DEVICE := qssi_au_sdv
PRODUCT_NAME := $(VENDOR_QTI_DEVICE)
PRODUCT_DEVICE := $(VENDOR_QTI_DEVICE)

PRODUCT_PACKAGES += \
    com.sdv.google.display_safety.services_bundle.apex \

# Add tools/utils
PRODUCT_PACKAGES += \
        harry_rpc_client \

TARGET_FS_CONFIG_GEN += device/google/sdv/sdv_core_base/config.fs

PRODUCT_PACKAGES += \
                 dice_handover_instance1 \
                 dice_handover_instance2 \
                 dice_handover_instance3 \


PRODUCT_COPY_FILES += device/google/sdv/sdv_base/vvmtruststore/vvmtruststore.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/vvmtruststore.rc

PRODUCT_PACKAGES += \
                 android.sdv.hardware.security.keymint-service.nonsecure \

PRODUCT_PROPERTY_OVERRIDES  += \
     ro.boot.sdv.instance_name=instance1 \
     ro.boot.sdv.boot_mode=unlocked

PRODUCT_PACKAGES += android.hidl.allocator@1.0-service

PRODUCT_PROPERTY_OVERRIDES += hwservicemanager.disabled=1

PRODUCT_PROPERTY_OVERRIDES += \
ro.boot.sdv.vvmfactorytrust=c779a73d0595a6814ba0414a419e99ad4026ad0feb603f2ad80ee6a9e4d1adb7 \
ro.sdv.ethernet.ready=true \
#ro.vendor.sdv.rpc.network.ready=true \

PRODUCT_PACKAGES += init_open_dice

include device/google/sdv/sdv_base/sepolicy/samples/device_sepolicy.mk
