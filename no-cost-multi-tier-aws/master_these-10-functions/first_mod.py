print("from mod 1 with love")

def main():
     print ("First mod name in MAIN method in 1st mod file:" , __name__)

if __name__ == '__main__':
    print("Run directly")
    main()
else:
    print ("Run from import")