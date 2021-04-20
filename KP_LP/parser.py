f = open('heritage.ged', 'r' )
o = open('heritage.pl', 'w')

name = dict()
sex = dict()

for line in f:
    if "INDI" in line:                              #id персоны
        ID = line [5:10]
    elif "GIVN" in line:                            #для имени 
        first_name = line [7:-1]                    #для фамилии
    elif "SURN" in line:
        last_name = line [7:-1]
        full_name = first_name + ' ' + last_name
    elif "_MARNM" in line:                          #для девичьей фамилии
        last_name = line [9:-1]
        full_name = first_name + ' ' + last_name
    elif "SEX" in line:                             #пол
        male_female = line [6]
    elif "_UID" in line:
        name[ID] = full_name
        sex[ID] = male_female
    elif "HUSB" in line:
        father = line [10:15]
    elif "WIFE" in line:
        mother = line [10:15]
    elif "CHIL" in line:
        child = line [10:15]

        o.write("parent('" + name[father] + "', '" + name[child] + "').\n")
        o.write("parent('" + name[mother] + "', '" + name[child] + "').\n")
f.seek(0)
o.write(" \n")

for line in f:
    if "HUSB" in line:
        father = line [10:15]
    elif "WIFE" in line:
        mother = line [10:15]
    elif "CHIL" in line:
        child = line [10:15]

        o.write("sex('" + name[father] + "', " + sex[father].lower() + " ).\n")
        o.write("sex('" + name[mother] + "', " + sex[mother].lower() + " ).\n")
        o.write("sex('" + name[child] + "', " + sex[child].lower() + " ).\n")

o.close()
f.close()