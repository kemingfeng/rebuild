/*
Copyright (c) REBUILD <https://getrebuild.com/> and/or its owners. All rights reserved.

rebuild is dual-licensed under commercial and open source licenses (GPLv3).
See LICENSE and COMMERCIAL in the project root for license information.
*/

package com.rebuild.core.metadata.easymeta;

import cn.devezhao.persist4j.Entity;
import cn.devezhao.persist4j.Field;
import cn.devezhao.persist4j.dialect.FieldType;
import com.alibaba.fastjson.JSON;
import com.rebuild.core.metadata.MetadataHelper;
import com.rebuild.core.service.trigger.RobotTriggerManager;
import com.rebuild.utils.JSONUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.util.Assert;

import java.util.Set;

/**
 * @author devezhao
 * @since 2020/11/17
 */
public abstract class EasyField extends BaseEasyMeta<Field> {
    private static final long serialVersionUID = 6027165766338449527L;

    private final DisplayType displayType;

    protected EasyField(Field field, DisplayType displayType) {
        super(field);
        this.displayType = displayType;
    }

    @Override
    public String getLabel() {
        return getRawMeta().getType() == FieldType.PRIMARY ? "ID" : super.getLabel();
    }

    @Override
    public boolean isUpdatable() {
        if (!getRawMeta().isUpdatable()) return false;

        Field field = getRawMeta();
        if (field.getType() == FieldType.REFERENCE) {
            Set<String> set = RobotTriggerManager.instance.getAutoReadonlyFields(field.getOwnEntity().getName());
            return !set.contains(field.getName());
        }
        return true;
    }

    @Override
    public boolean isBuiltin() {
        if (super.isBuiltin()) return true;

        Field field = getRawMeta();
        if (MetadataHelper.isCommonsField(field)) return true;

        if (field.getType() == FieldType.REFERENCE) {
            // 明细-引用主记录的字段也是内建
            // @see MetadataHelper#getDetailToMainField
            Entity hasMain = field.getOwnEntity().getMainEntity();
            return hasMain != null && hasMain.equals(field.getReferenceEntity()) && !field.isCreatable();
        }
        return false;
    }

    /**
     * @param fullName
     * @return
     */
    public String getDisplayType(boolean fullName) {
        DisplayType dt = getDisplayType();
        if (fullName) {
            return dt.getDisplayName() + " (" + dt.name() + ")";
        } else {
            return dt.name();
        }
    }

    /**
     * 获取 RB 封装类型
     *
     * @return
     */
    public DisplayType getDisplayType() {
        return displayType;
    }

    @Override
    public JSON toJSON() {
        return JSONUtils.toJSONObject(
                new String[] { "name", "label", "type", "nullable", "creatable", "updatable" },
                new Object[] { getName(), getLabel(), getDisplayType().name(),
                        getRawMeta().isNullable(), getRawMeta().isCreatable(), getRawMeta().isUpdatable() });
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "#" + getRawMeta().toString();
    }

    // --

    /**
     * 转换兼容值（默认实现仅支持转为文本值或同类型转换）
     *
     * @param value 原值
     * @param targetField 目标字段
     * @return
     */
    public Object convertCompatibleValue(Object value, EasyField targetField) {
        DisplayType targetType = targetField.getDisplayType();
        boolean is2Text = targetType == DisplayType.TEXT || targetType == DisplayType.NTEXT;
        if (is2Text) {
            return StringUtils.defaultIfBlank((String) wrapValue(value), null);
        }

        Assert.isTrue(targetField.getDisplayType() == getDisplayType(), "type-by-type is must");
        return value;
    }

    /**
     * 转换为易识别值（默认实现为转为字符串）
     *
     * @param value 原值
     * @return
     * @see com.rebuild.core.support.general.FieldValueHelper
     */
    public Object wrapValue(Object value) {
        if (value == null || StringUtils.isBlank(value.toString())) {
            return StringUtils.EMPTY;
        }
        return value.toString().trim();
    }

    /**
     * 默认值
     *
     * @return
     */
    public Object exprDefaultValue() {
        return StringUtils.defaultIfBlank((String) getRawMeta().getDefaultValue(), null);
    }

//    // 转换符合字段类型的值
//    abstract Object checkoutValue(Object rawValue);
}
