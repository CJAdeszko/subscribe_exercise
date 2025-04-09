This application is a command line tool for generating and printing receipts based on user input.

# Getting Started

### Clone the respository to your desired location
```
cd ~/your_desired_directory

git clone git@github.com:CJAdeszko/subscribe_exercise.git
```

### Run the tool using the executable
```
./bin/receipt_generator run
```
#### Note: If the executable does not work for some reason, ensure the file has the correct permission:
```
chmod +x bin/receipt_generator
```

### With the tool running, you should be prompted to enter receipt items
```
Welcome to the SUBSCRIBE receipt generator...
Please enter the items you would like to generate a receipt for and press Enter:
```

### You can enter items one line at a time or copy/paste the entire block of text:
```
Welcome to the SUBSCRIBE receipt generator...
Please enter the items you would like to generate a receipt for and press Enter:
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85

====================================================================================================
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

### Notes on usage: 

You must hit `Enter` twice to generate the receipt (once to submit the final item and once to generate), though this is unprompted in the CLI

If you wish to generate another receipt, you will need to re-run the tool using the `./bin/receipt_generator run` command again

# Assumptions

For the sake of this exercise the following assumptions were made: 
 
1. For items that are tax exempt, it was assumed that only items listed in the sample inputs would be input into the tool (chocolate, book(s), headache pills) as these items are verified in the code through the constant `ReceiptItem::TAX_EXEMPT_ITEMS`. 

2. User input would always follow the format [QUANTITY] [imported] [ITEM NAME] at [PRICE]

3. No form of persistence is required and it is okay for receipts to only exist in memory at the time they are generated, since no frameworks were permitted for use outside of testing purposes

4. No UI is necessary (asked to recruiter prior to beginning exercise)

# Notes on implementation

Design decisions and implementation were dictated, in part, by the time constraint and in the interest of being honest regarding time spent there are some things I didn't have time to refactor or implement that I would have liked to. 

For example: 
- Better user flow/prompting from the command line (hitting Enter twice with no prompt is not ideal, in my opinion)
- Allow user to provide a file path and parse a file for items to add to a Receipt
- Allow multiple receipts to be generated without having to run the `run` command for each receipt
- More dynamic parsing of user inputs to determine taxability 
- A more robust spec

Given more time or different constraints, a more dynamic approach to determining the tax exempt status of items and user input (either through additional user provided input/prompting or more intelligent parsing of data) would have been implemented. 
