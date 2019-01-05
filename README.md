# Terminal Design Procedures

contains dynamic/customizable design procedures for continuous flow structure and consistent alignment.

+Improves readability 🔖 | +satisfies obsessive organizers 🤣
------------ | ------------ | 

## Start
Procedure prints starting point of structure

## Command
Procedure prints aligned messages including descpriton underneath the command tb executed.

## Table
Procedure prints out columns & rows with automatic content size adaption and perfect alignment.

## Block
Procedure prints a literal Block with possible before and after text

## End
Procedure prints ending point of structure

---

### Getting Started

#### Start
```shell
Design_Start   # Start
```
#### Command
1. First Parameter indicates the number of delimeters to the right
2. Second can hold a message before the command
3. Third can hold a description beneath the to be executed command
4. Fourth holds the command
```shell
Design_Command "20" "Message: " "(e.g example)" "read test1"   # 20xdelim / Text / lower Description / Command  
```

#### Table
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

#### Block
1. First Parameter indicates the number of delimeters to the right
2. Second can hold a message before the block
3. Third can hold a description after the block
```shell
Design_Block "3" " Text " "Block"    # 3xdelim / PreText / PostText
```

#### Arrow
1. First Parameter indicates the number of delimeters to the right
2. Second can hold a message before the block
3. Third can hold a description after the block
```shell
Design_Arrow "3" "Input" "Test"    # 3xdelim / PreText / PostText
```

#### Line
1. First Parameter specifies the number of vertical delimeters 
```shell
Design_Line "1"    # 1xdelim
```

#### End
```shell
Design_End   # End
```

## Example Output:

![](https://i.imgur.com/A8VIZEo.png)
```shell
Design_Start
Design_Line "1"
Design_Block "3" " Text " "Block"
Design_Line "2"
Design_Table "COLUMN" "ColumnHead1" "ColumnHead2" "ColumnHead3" "ColumnHead4"
Design_Table "ROW" "Row1Col1" "Row1Col2" "Row1Col3" "Row1Col4"
Design_Table "ROW" "Row2Col1" "Row2Col2" "Row2Col3" "Row2Col4"
Design_Table "PRINT"
Design_Command "20" "Message: " "(e.g example)" "read test1"
Design_Arrow "3" "Input" "Test"
Design_End
```

---


### Author

* **me ;)**

#### Annotation

* Proc: Table - is pretty much oriented/based on MySQL's view.
