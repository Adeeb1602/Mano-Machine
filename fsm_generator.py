import pandas as pd
import os
import sys  


VERILOG_TEMPLATE = 'fsm_core_template.v'
OUTPUT_FILE = 'fsm_core.v'               

def generate_verilog_from_excel(excel_file_path):
    print(f"Reading FSM table from: {excel_file_path}...")
    try:
        # Read Excel, force Input/Output to be STRINGS
        df = pd.read_excel(excel_file_path, dtype={'Input': str, 'Output': str})
    except Exception as e:
        print(f"Error: Could not read Excel file. Check file or path.")
        print(f"Details: {e}")
        return

    # This is how we handle empty/template rows. Drop any row which has one of the cells empty
    original_count = len(df)
    df.dropna(subset=['Present State', 'Input', 'Next State', 'Output'], how='any', inplace=True)
    final_count = len(df)
    print(f"Found {final_count} valid transitions. {original_count - final_count} empty/partial rows were skipped.")

    print("Generating ROBUST logic (forcing 2-bit I/O)...")
    
    logic_buffer = ""
    grouped = df.groupby('Present State')

    for state, group in grouped:
        logic_buffer += f"\t\t{state}: begin\n"
        logic_buffer += "\t\t\tcase (x_in)\n"
        
        
        for index, row in group.iterrows():
            inp_val = str(row['Input']).zfill(2) # Pad with 0 if user just wrote "1"
            next_s = row['Next State']
            out_val = str(row['Output']).zfill(4) # Pad with 000 if user just wrote "1"

            
            logic_buffer += f"\t\t\t\t2'b{inp_val}: begin next_state = {next_s}; z = 4'b{out_val}; end\n"
            
        # DEFAULT PREVENTS LOCK-OUT IN CASE OF UNUSED INPUTS FOR A STATE
        logic_buffer += "\t\t\t\tdefault: begin next_state = S0; z = 4'b0000; end\n"
        
        logic_buffer += "\t\t\tendcase\n"
        logic_buffer += "\t\tend\n\n"

    # Read Template
    try:
        with open(VERILOG_TEMPLATE, 'r') as f:
            template_lines = f.readlines()
    except FileNotFoundError:
        print(f"Error: Template file '{VERILOG_TEMPLATE}' not found.")
        return

    # COMPILING THE WHOLE CONTENT TO WRITE
    final_lines = []
    in_gen_block = False
    
    for line in template_lines:
        if "//PYTHON-GEN-START" in line:
            final_lines.append(line)
            final_lines.append(logic_buffer)
            in_gen_block = True 
        elif "//PYTHON-GEN-END" in line:
            final_lines.append(line)
            in_gen_block = False
        elif not in_gen_block:
            final_lines.append(line)
    # REWROTE fsm_core.v
    with open(OUTPUT_FILE, 'w') as f:
        f.writelines(final_lines)

    print(f"Success! Overwrote {OUTPUT_FILE} with logic from {excel_file_path}.")


if __name__ == "__main__":
    
    
    if len(sys.argv) != 2:
        print("Error: You must provide exactly one Excel file name.")
        print(f"Usage: python {sys.argv[0]} my_fsm_table.xlsx")
        sys.exit(1) 

    
    excel_file_path = sys.argv[1]
    
    
    if not os.path.exists(excel_file_path):
        print(f"Error: File not found. No file named '{excel_file_path}' exists in this directory.")
        sys.exit(1)

    
    generate_verilog_from_excel(excel_file_path)