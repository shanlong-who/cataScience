# 数据集 C：合成 HIV 服务机构元数据

## 用途与单位

十家虚构卫生机构，每行一家，用于第 7 课的键核查、多对一关联、描述性汇总和绘图。这份表不代表实际机构或老挝总体人群。

| 字段 | 类型 | 允许值与含义 |
|---|---|---|
| `facility_id` | character | 唯一、非缺失的主键，对应 B 中有效、非缺失的机构编号。 |
| `district` | character | 虚构机构所在地区 A–E，与 B 中有记录的分配一致。不能用于填补患者缺失的居住地。 |
| `facility_type` | character | Hospital（医院）或 Health Center（卫生中心），为预先设定的教学属性。 |
| `vl_service` | logical | TRUE：可在机构内检测病毒载量；FALSE：无现场检测，但转诊或标本转运仍可使患者获得检测。 |

## 完整机构表

| facility_id | district | facility_type | vl_service |
|---|---|---|---|
| A01 | A | Hospital | TRUE |
| A02 | A | Health Center | FALSE |
| B01 | B | Hospital | TRUE |
| B02 | B | Health Center | FALSE |
| C01 | C | Hospital | FALSE |
| C02 | C | Health Center | TRUE |
| D01 | D | Hospital | TRUE |
| D02 | D | Health Center | FALSE |
| E01 | E | Hospital | TRUE |
| E02 | E | Health Center | FALSE |

## 关联与来源

生成过程读取 B 的最终参考 CSV，检查机构与地区的对应关系；若已观测分配冲突则停止。`validation/generate-dataset-c.R` 明确指定机构属性，没有根据患者检测状态或结果来估算。生成过程无需随机数或种子，不改写 A/B 的源文件。CSV 采用 UTF-8 编码，逻辑值使用 TRUE/FALSE。

B 中多条患者记录可属于同一机构，因此外键可以重复。其中两条记录缺失 `facility_id`，关联后仍未匹配；另有两条患者地区缺失但机构已知，不能把机构所在地当作居住地。关联前将 B 的 `district` 重命名为 `patient_district`，将 C 的重命名为 `facility_district`。仅使用 `facility_id` 关联，设定 `na_matches = "never"`，核实 C 中键唯一，并要求 `relationship = "many-to-one"`。关联审计应保留 B 的全部 604 条记录。

## 结果解释

机构提供现场检测与患者在 2025 年是否报告检测是两个不同的变量。B 的 `vl_tested` 取值为 Yes、No、Unknown 或空白，未经明确定义的转换，不能与 TRUE 比较。报告检测并不保证有可用的实验室结果。描述性的组间差异不能证明因果效应。

患者身份和入选资格的未决问题，请查 B 的数据字典和来源核查表。保存原始输入并声明分析子集，不从教学样本推算患者总体数或全国估计。
