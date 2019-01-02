# Terminal Design Procedures

contains dynamic/customizable design procedures for continuous flow structure and consistent alignment.

:+ Improves readability | 
------------ | 


## Table

Procedure for printing out tables with automatic content size adaption.

### Getting Started

1. First specify as many columns you'd like, right after the "COLUMN" parameter.
```shell
Design_Table "COLUMN" "ColumnHead1" "ColumnHead2" "ColumnHead3" "ColumnHead4"   # 4xColumns
```
2. Secondly add numerous lines for rows, corresponding to number of columns.
```shell
Design_Table "ROW" "Row1Col1" "Row1Col2" "Row1Col3" "Row1Col4"    # Row Number 1 / 4 Columns
Design_Table "ROW" "Row2Col1" "Row2Col2" "Row2Col3" "Row2Col4"    # Row Number 2 / 4 Columns
```
3. Last but not least call the printing Part to evaluate all predecessors rows and columns.
```shell
Design_Table "PRINT"    # takes all predecessors rows and columns and prints
```

### Example Output:

![](https://i.imgur.com/6KXaDqU.png)
```shell
Design_Table "COLUMN" "ColumnHead1" "ColumnHead2" "ColumnHead3" "ColumnHead4"
Design_Table "ROW" "Row1Col1" "Row1Col2" "Row1Col3" "Row1Col4"
Design_Table "ROW" "Row2Col1" "Row2Col2" "Row2Col3" "Row2Col4"
Design_Table "PRINT"
```

---


### Author

* **me ;)**

#### Annotation

* Proc: Table - is pretty much oriented/based on MySQL's view.
