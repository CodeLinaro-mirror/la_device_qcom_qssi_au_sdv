#include device/google/sdv/sdv_ivi_base/BoardConfig.mk
include device/google/sdv/sdv_core_base/BoardConfig.mk
include device/qcom/qssi_au/BoardConfig.mk
BOARD_AVB_VBMETA_SYSTEM :=
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH :=
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM :=
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX :=
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION :=

SDV_RPC_INTERFACE := sdv_rpc
BOARD_BOOTIMG_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
AB_OTA_PARTITIONS := system system_ext product

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS := device/google/sdv/sdv_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_cf/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_base/vvmtruststore/sepolicy/vvmtruststore/private

SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS :=  device/google/sdv/sdv_base/sepolicy/system_ext/public \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/public

PRODUCT_PRIVATE_SEPOLICY_DIRS :=    device/google/sdv/sdv_base/sepolicy/samples/product/private \
                                    device/google/sdv/sdv_core_base/sepolicy/product/private \
                                    device/google/sdv/sdv_core_base/sepolicy/samples/product/private

PRODUCT_PUBLIC_SEPOLICY_DIRS :=     device/google/sdv/sdv_base/sepolicy/product/public \
                                    device/qcom/sepolicy/generic/product/public

BOARD_PRODUCT_SEPOLICY_DIRS += \
    packages/services/display_safety/service/product/sepolicy \
# Allow HAR SDV Service Bundles to use sockets.
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    packages/services/display_safety/service/product/har_sdv_service_bundle_apex/lifecycle/sepolicy/public \

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    packages/services/display_safety/service/product/har_sdv_service_bundle_apex/lifecycle/sepolicy \

$(call soong_config_set,sdv_authz,acl_provider_type,sdv_acl_provider)
