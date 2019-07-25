-- PROGRAM:PJBMR001_多階式用料明細表
-- VERSION:2012/04/25
-- AUTHOR:VALLY
-- UPDATE:2012/06/14 去除展階料號的空格

(
  SELECT 0                                              "TOP_PLAN_LEVEL",               -- 版次
         MSIB.SEGMENT1                                  "TOP_ITEM",                     -- 上階料號(查詢料號)
         MSIT.DESCRIPTION                               "TOP_DESCRIPTION",              -- 上階料號摘要
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_1,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_T",   -- 替代結構_LEVEL1
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_2,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_SUB",   -- 替代結構_LEVEL2
         BL.SOURCE_BILL_SEQUENCE_ID_1                   "LEVEL_1",                      -- 展階序列ID_LEVEL1
         BL.COMPONENT_ITEM_ID_1                         "COMPONENT_1",                  -- 各階用料_LEVEL1
         0                                              "LEVEL_2",                      -- 展階序列ID_LEVEL2
         0                                              "COMPONENT_2",                  -- 各階用料_LEVEL2
         0                                              "LEVEL_3",                      -- 展階序列ID_LEVEL3
         0                                              "COMPONENT_3",                  -- 各階用料_LEVEL3
         0                                              "LEVEL_4",                      -- 展階序列ID_LEVEL4
         0                                              "COMPONENT_4",                  -- 各階用料_LEVEL4
         BL.PLAN_LEVEL_1                                "COMPONENT_PLAN_LEVEL",         -- 層次(LEVEL1)
         MSIB2.SEGMENT1                                 "COMPONENT_ITEM",               -- 下階料號(展階料號)
         MSIT2.DESCRIPTION                              "DESCRIPTION",                  -- 下階料號摘要
         BL.OPERATION_SEQ_NUM_1                         "OPERATION_SEQ_NUM",            -- 作業序號
         BL.ALTERNATE_BOM_DESIGNATOR_1                  "ALTERNATE_BOM_DESIGNATOR_C",   -- 下階料號替代結構
         MSIB2.PRIMARY_UOM_CODE                         "UOM",                          -- 單位
         BL.COMPONENT_QUANTITY_1                        "COMPONENT_QUANTITY",           -- 組成用量
         BL.COMPONENT_YIELD_FACTOR_1                    "COMPONENT_YIELD_FACTOR",       -- 良品率
         FLV.MEANING                                    "WIP_SUPPLY",                   -- 供給型態
         BL.SUPPLY_SUBINVENTORY_1                       "SUBINVENTORY"                  -- 倉庫
  FROM MTL_SYSTEM_ITEMS_B               MSIB,
       MTL_SYSTEM_ITEMS_B               MSIB2,
       MTL_SYSTEM_ITEMS_TL              MSIT,
       MTL_SYSTEM_ITEMS_TL              MSIT2,
       FND_LOOKUP_VALUES                FLV,
      (
        SELECT BOM1.PLAN_LEVEL                "PLAN_LEVEL_1",
               BOM1.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_1",
               BOM1.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_1",
               BOM1.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_1",
               BOM1.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_1",
               BOM1.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_1",
               BOM1.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_1",
               BOM1.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_1",
               BOM1.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_1",
               BOM1.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_1",
               BOM2.PLAN_LEVEL                "PLAN_LEVEL_2",
               BOM2.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_2",
               BOM2.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_2",
               BOM2.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_2",
               BOM2.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_2",
               BOM2.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_2",
               BOM2.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_2",
               BOM2.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_2",
               BOM2.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_2",
               BOM2.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_2"
        FROM
            (
              SELECT 1                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM1
            
            LEFT JOIN
            (
              SELECT 2                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM2
            ON BOM1.COMPONENT_ITEM_ID = BOM2.ASSEMBLY_ITEM_ID
            
            LEFT JOIN
            (
              SELECT 3                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM3
            ON BOM2.COMPONENT_ITEM_ID = BOM3.ASSEMBLY_ITEM_ID

            LEFT JOIN
            (
              SELECT 4                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM4
            ON BOM3.COMPONENT_ITEM_ID = BOM4.ASSEMBLY_ITEM_ID
        )  BL

    WHERE MSIB.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
      AND BL.ASSEMBLY_ITEM_ID_1 = MSIB.INVENTORY_ITEM_ID
      AND BL.COMPONENT_ITEM_ID_1 = MSIB2.INVENTORY_ITEM_ID
      AND BL.WIP_SUPPLY_TYPE_1 = FLV.LOOKUP_CODE
      AND MSIB.ORGANIZATION_ID = 83
      AND MSIT.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
      AND MSIT.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
      AND MSIT2.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
      AND MSIT2.INVENTORY_ITEM_ID = MSIB2.INVENTORY_ITEM_ID
    AND MSIB.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB.BOM_ITEM_TYPE = 4  --標準用料表
    AND MSIB2.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB2.BOM_ITEM_TYPE = 4  --標準用料表
    AND FLV.LOOKUP_TYPE = 'WIP_SUPPLY'
    AND FLV.LANGUAGE = USERENV('LANG')
    AND MSIB.SEGMENT1 BETWEEN NVL(:P_ITEM_S,MSIB.SEGMENT1) AND NVL(:P_ITEM_E,MSIB.SEGMENT1)
    AND pj_get_category_f(MSIB.SEGMENT1,'PACKAGE') = NVL(:P_PACKAGE,pj_get_category_f(MSIB.SEGMENT1,'PACKAGE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FAMILY') = NVL(:P_FAMILY,pj_get_category_f(MSIB.SEGMENT1,'FAMILY'))
    AND pj_get_category_f(MSIB.SEGMENT1,'TYPE') = NVL(:P_TYPE,pj_get_category_f(MSIB.SEGMENT1,'TYPE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FUNCTION') = NVL(:P_FUNCTION,pj_get_category_f(MSIB.SEGMENT1,'FUNCTION'))
)

UNION 

(
  SELECT 0                                              "TOP_PLAN_LEVEL",               -- 版次
         MSIB.SEGMENT1                                  "TOP_ITEM",                     -- 上階料號(查詢料號)
         MSIT.DESCRIPTION                               "TOP_DESCRIPTION",                  -- 上階料號摘要
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_1,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_T",   -- 替代結構_LEVEL1
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_3,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_SUB",   -- 替代結構_LEVEL3
         BL.SOURCE_BILL_SEQUENCE_ID_1                   "LEVEL_1",                      -- 展階序列ID_LEVEL1
         BL.COMPONENT_ITEM_ID_1                         "COMPONENT_1",                  -- 各階用料_LEVEL1
         BL.SOURCE_BILL_SEQUENCE_ID_2                   "LEVEL_2",                      -- 展階序列ID_LEVEL2
         BL.COMPONENT_ITEM_ID_2                         "COMPONENT_2",                  -- 各階用料_LEVEL2
         0                                              "LEVEL_3",                      -- 展階序列ID_LEVEL3
         0                                              "COMPONENT_3",                  -- 各階用料_LEVEL3
         0                                              "LEVEL_4",                      -- 展階序列ID_LEVEL4
         0                                              "COMPONENT_4",                  -- 各階用料_LEVEL4
         BL.PLAN_LEVEL_2                                "COMPONENT_PLAN_LEVEL",         -- 層次(LEVEL2)
         MSIB2.SEGMENT1                                 "COMPONENT_ITEM",               -- 下階料號(展階料號)
         MSIT2.DESCRIPTION                              "DESCRIPTION",                  -- 下階料號摘要
         BL.OPERATION_SEQ_NUM_2                         "OPERATION_SEQ_NUM",            -- 作業序號
         BL.ALTERNATE_BOM_DESIGNATOR_2                  "ALTERNATE_BOM_DESIGNATOR_C",   -- 下階料號替代結構
         MSIB2.PRIMARY_UOM_CODE                         "UOM",                          -- 單位
         BL.COMPONENT_QUANTITY_2                        "COMPONENT_QUANTITY",           -- 組成用量
         BL.COMPONENT_YIELD_FACTOR_2                    "COMPONENT_YIELD_FACTOR",       -- 良品率
         FLV.MEANING                                    "WIP_SUPPLY",                   -- 供給型態
         BL.SUPPLY_SUBINVENTORY_2                       "SUBINVENTORY"                  -- 倉庫
  FROM MTL_SYSTEM_ITEMS_B               MSIB,
       MTL_SYSTEM_ITEMS_B               MSIB2,
        MTL_SYSTEM_ITEMS_TL              MSIT,
       MTL_SYSTEM_ITEMS_TL              MSIT2,
       FND_LOOKUP_VALUES                FLV,
      (
        SELECT BOM1.PLAN_LEVEL                "PLAN_LEVEL_1",
               BOM1.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_1",
               BOM1.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_1",
               BOM1.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_1",
               BOM1.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_1",
               BOM1.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_1",
               BOM1.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_1",
               BOM1.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_1",
               BOM1.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_1",
               BOM1.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_1",
               BOM2.PLAN_LEVEL                "PLAN_LEVEL_2",
               BOM2.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_2",
               BOM2.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_2",
               BOM2.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_2",
               BOM2.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_2",
               BOM2.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_2",
               BOM2.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_2",
               BOM2.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_2",
               BOM2.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_2",
               BOM2.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_2",
               BOM3.PLAN_LEVEL                "PLAN_LEVEL_3",
               BOM3.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_3",
               BOM3.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_3",
               BOM3.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_3",
               BOM3.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_3",
               BOM3.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_3",
               BOM3.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_3",
               BOM3.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_3",
               BOM3.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_3",
               BOM3.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_3"
        FROM
            (
              SELECT 1                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM1

            LEFT JOIN
            (
              SELECT 2                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM2
            ON BOM1.COMPONENT_ITEM_ID = BOM2.ASSEMBLY_ITEM_ID

            LEFT JOIN
            (
              SELECT 3                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM3
            ON BOM2.COMPONENT_ITEM_ID = BOM3.ASSEMBLY_ITEM_ID
      )  BL

  WHERE MSIB.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
    AND BL.ASSEMBLY_ITEM_ID_1 = MSIB.INVENTORY_ITEM_ID
    AND BL.COMPONENT_ITEM_ID_2 = MSIB2.INVENTORY_ITEM_ID
    AND BL.WIP_SUPPLY_TYPE_2 = FLV.LOOKUP_CODE
    AND MSIB.ORGANIZATION_ID = 83
     AND MSIT.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
      AND MSIT.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
      AND MSIT2.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
      AND MSIT2.INVENTORY_ITEM_ID = MSIB2.INVENTORY_ITEM_ID
    AND MSIB.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB.BOM_ITEM_TYPE = 4  --標準用料表
    AND MSIB2.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB2.BOM_ITEM_TYPE = 4  --標準用料表
    AND FLV.LOOKUP_TYPE = 'WIP_SUPPLY'
    AND FLV.LANGUAGE = USERENV('LANG')
    AND MSIB.SEGMENT1 BETWEEN NVL(:P_ITEM_S,MSIB.SEGMENT1) AND NVL(:P_ITEM_E,MSIB.SEGMENT1)
    AND pj_get_category_f(MSIB.SEGMENT1,'PACKAGE') = NVL(:P_PACKAGE,pj_get_category_f(MSIB.SEGMENT1,'PACKAGE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FAMILY') = NVL(:P_FAMILY,pj_get_category_f(MSIB.SEGMENT1,'FAMILY'))
    AND pj_get_category_f(MSIB.SEGMENT1,'TYPE') = NVL(:P_TYPE,pj_get_category_f(MSIB.SEGMENT1,'TYPE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FUNCTION') = NVL(:P_FUNCTION,pj_get_category_f(MSIB.SEGMENT1,'FUNCTION'))
)

UNION

(
  SELECT 0                                              "TOP_PLAN_LEVEL",               -- 版次
         MSIB.SEGMENT1                                  "TOP_ITEM",                     -- 上階料號(查詢料號)
         MSIT.DESCRIPTION                               "TOP_DESCRIPTION",                  -- 上階料號摘要
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_1,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_T",   -- 替代結構_LEVEL1
         NVL(BL.ALTERNATE_BOM_DESIGNATOR_4,'PRIMARY')   "ALTERNATE_BOM_DESIGNATOR_SUB",   -- 替代結構_LEVEL4
         BL.SOURCE_BILL_SEQUENCE_ID_1                   "LEVEL_1",                      -- 展階序列ID_LEVEL1
         BL.COMPONENT_ITEM_ID_1                         "COMPONENT_1",                  -- 各階用料_LEVEL1
         BL.SOURCE_BILL_SEQUENCE_ID_2                   "LEVEL_2",                      -- 展階序列ID_LEVEL2
         BL.COMPONENT_ITEM_ID_2                         "COMPONENT_2",                  -- 各階用料_LEVEL2
         BL.SOURCE_BILL_SEQUENCE_ID_3                   "LEVEL_3",                      -- 展階序列ID_LEVEL3
         BL.COMPONENT_ITEM_ID_3                         "COMPONENT_3",                  -- 各階用料_LEVEL3
         0                                              "LEVEL_4",                      -- 展階序列ID_LEVEL4
         0                                              "COMPONENT_4",                  -- 各階用料_LEVEL4
         BL.PLAN_LEVEL_3                                "COMPONENT_PLAN_LEVEL",         -- 層次(LEVEL3)
         MSIB2.SEGMENT1                                 "COMPONENT_ITEM",               -- 下階料號(展階料號)
         MSIT2.DESCRIPTION                              "DESCRIPTION",                  -- 下階料號摘要
         BL.OPERATION_SEQ_NUM_3                         "OPERATION_SEQ_NUM",            -- 作業序號
         BL.ALTERNATE_BOM_DESIGNATOR_3                  "ALTERNATE_BOM_DESIGNATOR_C",   -- 下階料號替代結構
         MSIB2.PRIMARY_UOM_CODE                         "UOM",                          -- 單位
         BL.COMPONENT_QUANTITY_3                        "COMPONENT_QUANTITY",           -- 組成用量
         BL.COMPONENT_YIELD_FACTOR_3                    "COMPONENT_YIELD_FACTOR",       -- 良品率
         FLV.MEANING                                    "WIP_SUPPLY",                   -- 供給型態
         BL.SUPPLY_SUBINVENTORY_3                       "SUBINVENTORY"                  -- 倉庫
  FROM MTL_SYSTEM_ITEMS_B               MSIB,
       MTL_SYSTEM_ITEMS_B               MSIB2,
       MTL_SYSTEM_ITEMS_TL              MSIT,
       MTL_SYSTEM_ITEMS_TL              MSIT2,
       FND_LOOKUP_VALUES                FLV,
      (
        SELECT BOM1.PLAN_LEVEL                "PLAN_LEVEL_1",
               BOM1.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_1",
               BOM1.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_1",
               BOM1.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_1",
               BOM1.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_1",
               BOM1.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_1",
               BOM1.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_1",
               BOM1.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_1",
               BOM1.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_1",
               BOM1.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_1",
               BOM2.PLAN_LEVEL                "PLAN_LEVEL_2",
               BOM2.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_2",
               BOM2.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_2",
               BOM2.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_2",
               BOM2.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_2",
               BOM2.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_2",
               BOM2.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_2",
               BOM2.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_2",
               BOM2.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_2",
               BOM2.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_2",
               BOM3.PLAN_LEVEL                "PLAN_LEVEL_3",
               BOM3.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_3",
               BOM3.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_3",
               BOM3.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_3",
               BOM3.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_3",
               BOM3.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_3",
               BOM3.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_3",
               BOM3.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_3",
               BOM3.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_3",
               BOM3.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_3",
               BOM4.PLAN_LEVEL                "PLAN_LEVEL_4",
               BOM4.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID_4",
               BOM4.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR_4",
               BOM4.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID_4",
               BOM4.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID_4",
               BOM4.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM_4",
               BOM4.COMPONENT_QUANTITY        "COMPONENT_QUANTITY_4",
               BOM4.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR_4",
               BOM4.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE_4",
               BOM4.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY_4"
        FROM
            (
              SELECT 1                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM1

            LEFT JOIN
            (
              SELECT 2                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM2
            ON BOM1.COMPONENT_ITEM_ID = BOM2.ASSEMBLY_ITEM_ID

            LEFT JOIN
            (
              SELECT 3                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM3
            ON BOM2.COMPONENT_ITEM_ID = BOM3.ASSEMBLY_ITEM_ID

            LEFT JOIN
            (
              SELECT 4                             "PLAN_LEVEL",
                     BOM.SOURCE_BILL_SEQUENCE_ID   "SOURCE_BILL_SEQUENCE_ID",
                     BOM.ALTERNATE_BOM_DESIGNATOR  "ALTERNATE_BOM_DESIGNATOR",
                     BOM.ASSEMBLY_ITEM_ID          "ASSEMBLY_ITEM_ID",
                     BIC.COMPONENT_ITEM_ID         "COMPONENT_ITEM_ID",
                     BIC.OPERATION_SEQ_NUM         "OPERATION_SEQ_NUM",
                     BIC.COMPONENT_QUANTITY        "COMPONENT_QUANTITY",
                     BIC.COMPONENT_YIELD_FACTOR    "COMPONENT_YIELD_FACTOR",
                     BIC.WIP_SUPPLY_TYPE           "WIP_SUPPLY_TYPE",
                     BIC.SUPPLY_SUBINVENTORY       "SUPPLY_SUBINVENTORY"
                FROM BOM_BILL_OF_MATERIALS       BOM,
                     BOM_INVENTORY_COMPONENTS    BIC
               WHERE BOM.ORGANIZATION_ID = 83
                 AND BOM.SOURCE_BILL_SEQUENCE_ID = BIC.BILL_SEQUENCE_ID
                 AND BIC.DISABLE_DATE IS NULL
                 AND BIC.IMPLEMENTATION_DATE IS NOT NULL
            )  BOM4
            ON BOM3.COMPONENT_ITEM_ID = BOM4.ASSEMBLY_ITEM_ID
      )  BL

  WHERE MSIB.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
    AND BL.ASSEMBLY_ITEM_ID_1 = MSIB.INVENTORY_ITEM_ID
    AND BL.COMPONENT_ITEM_ID_3 = MSIB2.INVENTORY_ITEM_ID
    AND BL.WIP_SUPPLY_TYPE_3 = FLV.LOOKUP_CODE
    AND MSIB.ORGANIZATION_ID = 83
     AND MSIT.ORGANIZATION_ID = MSIB.ORGANIZATION_ID
      AND MSIT.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
      AND MSIT2.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
      AND MSIT2.INVENTORY_ITEM_ID = MSIB2.INVENTORY_ITEM_ID
    AND MSIB.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB.BOM_ITEM_TYPE = 4  --標準用料表
    AND MSIB2.INVENTORY_ITEM_STATUS_CODE = 'Active'  --有效料號
    AND MSIB2.BOM_ITEM_TYPE = 4  --標準用料表
    AND FLV.LOOKUP_TYPE = 'WIP_SUPPLY'
    AND FLV.LANGUAGE = USERENV('LANG')
    AND MSIB.SEGMENT1 BETWEEN NVL(:P_ITEM_S,MSIB.SEGMENT1) AND NVL(:P_ITEM_E,MSIB.SEGMENT1)
    AND pj_get_category_f(MSIB.SEGMENT1,'PACKAGE') = NVL(:P_PACKAGE,pj_get_category_f(MSIB.SEGMENT1,'PACKAGE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FAMILY') = NVL(:P_FAMILY,pj_get_category_f(MSIB.SEGMENT1,'FAMILY'))
    AND pj_get_category_f(MSIB.SEGMENT1,'TYPE') = NVL(:P_TYPE,pj_get_category_f(MSIB.SEGMENT1,'TYPE'))
    AND pj_get_category_f(MSIB.SEGMENT1,'FUNCTION') = NVL(:P_FUNCTION,pj_get_category_f(MSIB.SEGMENT1,'FUNCTION'))
)

ORDER BY TOP_ITEM,ALTERNATE_BOM_DESIGNATOR_T,ALTERNATE_BOM_DESIGNATOR_SUB,
         LEVEL_1,COMPONENT_1,LEVEL_2,COMPONENT_2,LEVEL_3,COMPONENT_3,LEVEL_4,COMPONENT_4,COMPONENT_PLAN_LEVEL