# Loaded before hisilicon-opensdk.mk by general/external.mk.
# The CV2005 fork does not contain kernel/obj. Restore only CV6xx blobs
# from a pinned upstream tree; keep the fork's sources and clock changes.
ifeq ($(OPENIPC_SOC_FAMILY),hi3516cv6xx)
HISILICON_OPENSDK_CV6XX_BLOBS_REV = 9a6391064e5ed2cdf4d862a610bbb037af380adf
HISILICON_OPENSDK_EXTRA_DOWNLOADS += https://github.com/OpenIPC/openhisilicon/archive/$(HISILICON_OPENSDK_CV6XX_BLOBS_REV).tar.gz

define HISILICON_OPENSDK_RESTORE_CV6XX_BLOBS
	# Refuse to silently combine blobs with a different module build layout.
	tar -xOf $(HISILICON_OPENSDK_DL_DIR)/$(HISILICON_OPENSDK_CV6XX_BLOBS_REV).tar.gz openhisilicon-$(HISILICON_OPENSDK_CV6XX_BLOBS_REV)/kernel/hi3516cv6xx.kbuild > $(@D)/.cv6xx-upstream.kbuild
	cmp $(@D)/.cv6xx-upstream.kbuild $(@D)/kernel/hi3516cv6xx.kbuild
	rm -f $(@D)/.cv6xx-upstream.kbuild
	tar -xzf $(HISILICON_OPENSDK_DL_DIR)/$(HISILICON_OPENSDK_CV6XX_BLOBS_REV).tar.gz -C $(@D) --strip-components=1 openhisilicon-$(HISILICON_OPENSDK_CV6XX_BLOBS_REV)/kernel/obj/hi3516cv6xx
	set -e; for mod in acodec adec aenc ai aiisp aio ao base chnl devstat h264e h265e isp ive jpege pm rc rgn svac3e svp_npu sys user_proc uvc vb vca venc vgs vi vpp vpss; do \
		test -s $(@D)/kernel/obj/hi3516cv6xx/hi_$${mod}.o || { echo "Missing CV6xx vendor object: hi_$${mod}.o" >&2; exit 1; }; \
	done
endef
HISILICON_OPENSDK_POST_EXTRACT_HOOKS += HISILICON_OPENSDK_RESTORE_CV6XX_BLOBS
endif
