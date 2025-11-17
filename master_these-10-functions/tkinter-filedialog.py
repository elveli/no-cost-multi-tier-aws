from tkinter import filedialog as fd

path: str = fd.askopenfilename(title='Select a file',
                               filetypes=(('PDF', '*.pdf')))


#print(path)