/*!
Copyright (c) REBUILD <https://getrebuild.com/> and/or its owners. All rights reserved.

rebuild is dual-licensed under commercial and open source licenses (GPLv3).
See LICENSE and COMMERCIAL in the project root for license information.
*/

package com.rebuild.core.support.general;

import cn.devezhao.persist4j.Field;
import com.google.zxing.BarcodeFormat;
import com.rebuild.TestSupport;
import com.rebuild.core.metadata.MetadataHelper;
import org.junit.jupiter.api.Test;

/**
 * @author devezhao
 * @since 2020/6/5
 */
public class BarCodeGeneratorTest extends TestSupport {

    @Test
    public void getBarCodeContent() {
        Field barcodeField = MetadataHelper.getEntity(TestAllFields).getField("barcode");
        System.out.println(BarCodeSupport.getBarCodeContent(barcodeField, null));
    }

    @Test
    public void saveBarCode() {
        System.out.println(BarCodeSupport.saveCode("CODE128", BarcodeFormat.CODE_128, 80));
        System.out.println(BarCodeSupport.saveCode("123ABC支持中文", BarcodeFormat.QR_CODE, 200));
    }
}