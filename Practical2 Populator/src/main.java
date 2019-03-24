import java.io.*;
import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class main {

    public static void main(String[] args) throws SQLException, IOException, ParseException {
        String dburl = "jdbc:mariadb://feb7.host.cs.st-andrews.ac.uk/feb7_cs3101_Practical2_db";
        String uname = "feb7";
        String passwd = "9C44Tx6!sZe9R7";
        Connection conn = DriverManager.getConnection(dburl, uname, passwd);


        makeTables(conn);

        createQuery1(conn);
        createQuery2(conn);
        createQuery3(conn);

        createTrigger1(conn);
        createTrigger2(conn);
        createProcedure3(conn);

        populateFromPeople(conn);
        populateFromPublisher(conn);
        populateFromBooks(conn);
        populateReviewsandPurchases(conn);

        setUpPassword(conn);

    }

    private static void createTrigger1(Connection conn) throws SQLException {
        //step 1 - cannot have a review out of the range 1 to 5, throw an error if not
        String review5Trigger = "create trigger 5StarRange before insert on audiobookReview for each row " +
                "begin " +
                "if new.rating not in (1,2,3,4,5) then signal sqlstate '45001' set message_text = \"Out of 5 star range\";" +
                "end if;" +
                "end" ;
        //step 2 - double check that reviews are correctly marked as verified or not
        String checkVerified = "create trigger checkVerified before insert on audiobookReview for each row " +
                "begin " +
                "if new.customer_ID + new.ISBN in (select customer_ID + ISBN from audiobookPurchase) then set new.verified = TRUE;" +
                "else set new.verified = FALSE;" +
                "end if;" +
                "end";

        //step 3 - mark a review as verififed if the person buys a book
        String updateVerifiedStatus = "create trigger updatedVerified before insert on audiobookPurchase for each row " +
                "begin " +
                "if new.customer_ID + new.ISBN in (select customer_ID + ISBN from audiobookReview) then " +
                "update audiobookReview " +
                "set verified = TRUE where audiobookReview.customer_ID = new.customer_ID and audiobookReview.ISBN = new.ISBN ;" +
                "end if;" +
                "end";

        Statement makeTrigger = conn.createStatement();
        makeTrigger.execute("drop trigger if exists 5StarRange");
        makeTrigger.execute("drop trigger if exists checkVerified");
        makeTrigger.execute("drop trigger if exists updatedVerified");


        makeTrigger.execute(review5Trigger);
        makeTrigger.execute(checkVerified);
        makeTrigger.execute(updateVerifiedStatus);


       /* makeTrigger.execute("insert into audiobookReview values (3," +
                " '978-1408855652', " +
                "5," +
                "\"Harry Potter and the Philosopher's Stone\"," +
                "'comment', " +
                "FALSE)");

        makeTrigger.execute("insert into audiobookPurchase values " +
                "(1," +
                "'860-1404211171'," +
                "'2018-01-23 00:00:00');");*/
    }

    private static void createTrigger2(Connection conn) throws SQLException {

        String ageCheckTrigger = "create trigger ageCheck before insert on audiobookPurchase for each row " +
                "begin " +
                "if (select DATEDIFF(now(),person.date_of_birth)/365 from person where person.ID = new.customer_id) " +
                "< " +
                "(select age_rating from audiobook where audiobook.ISBN = new.ISBN)" +
                " then " +
                "signal sqlstate '45002' set message_text = \"Too young\";" +
                "end if;" +
                "end" ;

        Statement makeTrigger = conn.createStatement();
        makeTrigger.execute("drop trigger if exists ageCheck");

        makeTrigger.execute(ageCheckTrigger);

       /* makeTrigger.execute("insert into audiobookPurchase values " +
                "(9," +
                "'978-1611749731'," +
                "'2018-01-23 00:00:00');");*/
    }

    private static void createProcedure3(Connection conn) throws SQLException {

        String addCustomer =
                "create procedure addCustomer (f varchar(20), m varchar(5), s varchar(20), dob DATE, email TINYTEXT ) " +
                "begin " +
                        "if not exists (select forename, middle_initials, surname from person where forename = f and middle_initials = m and surname = s) then " +
                "insert into person (forename, middle_initials,surname,date_of_birth) values (f, m, s, dob)  ;" +
                        "end if;"+
                "insert into customer values ((select ID from person where person.forename = f and person.middle_initials = m and person.surname = s),email); " +
                "end;" ;

        String addContributor =
                "create procedure addContributor (f varchar(20), m varchar(5), s varchar(20), dob DATE, bio TEXT ) " +
                        "begin " +
                        "if not exists (select forename from person where person.forename = f) then " +
                        "insert into person (forename, middle_initials,surname,date_of_birth) values (f, m, s, dob)  ;" +
                        "end if;"+
                        "insert into contributor values ((select ID from person where person.forename = f and person.middle_initials = m and person.surname = s),bio); " +
                        "end;" ;


        Statement makeProc = conn.createStatement();
        makeProc.execute("drop procedure if exists addCustomer");
        makeProc.execute("drop procedure if exists addContributor");

        /*makeProc.execute("create role public;");        To prevent insertion i would add all users connecting to a public role and revoke their privillage to insert into person
        makeProc.execute("set default role public;");
        makeProc.execute("revoke insert on person from public");*/

        makeProc.execute(addCustomer);
        makeProc.execute(addContributor);
    }

    private static void createQuery1(Connection conn) throws SQLException {
        String getCustomerPeople = "create view onlyCustomers as select distinct person.ID as PID, forename, middle_initials, surname , email_address from person, " +
                "customer where person.ID = customer.ID order by forename asc;";



        String q1 ="create view q1 as " +
                "select distinct PID, forename , middle_initials, surname,case 1 " +
                "when PID not in (select customer_ID from audiobookPurchase) then 0 " +
                "else sum(purchase_price) " +
                "end as totalSpend from " +
                "onlyCustomers, audiobook, audiobookPurchase " +
                "where ((PID not in (select customer_ID from audiobookPurchase)) or (PID = audiobookPurchase.customer_ID and audiobook.ISBN = audiobookPurchase.ISBN ) ) " +
                "group by PID order by totalSpend desc, forename desc;" ;


        Statement makeViews = conn.createStatement();
        makeViews.execute("drop view if exists onlyCustomers");
        makeViews.execute("drop view if exists customerPurchases");
        makeViews.execute("drop view if exists customerSpend");
        makeViews.execute("drop view if exists q1");


        makeViews.execute(getCustomerPeople);
        makeViews.execute(q1);

    } //needs to display everyone

    private static void createQuery2(Connection conn) throws SQLException {
        //FIND ISBN NOT IN purchase table

        String noPurchaseData = "create view q2 as select ISBN, title from audiobook where ISBN not in (select ISBN from audiobookPurchase) order by title desc;";

       Statement makeViews = conn.createStatement();
        makeViews.execute("drop view if exists q2");
        makeViews.execute(noPurchaseData);

        PreparedStatement q = conn.prepareStatement("select * from q2");
        ResultSet id = q.executeQuery();

        while(id.next()){
            String ISBN = id.getString(1);
            String title = id.getString(2);

            System.out.println(ISBN + " " + title);

        };
        id.close();

    }

    private static void createQuery3(Connection conn) throws SQLException {
        //step 1 : List all contributors who have bought audio books they authored and/or narrated

        String contributorBuysOwnBook= "create view boughtOwnBook as select distinct contributor.ID as bobID, title from contributor, audiobook, audiobookPurchase, audiobookAuthor where " +
                "contributor.ID = audiobookPurchase.customer_ID  and audiobookPurchase.ISBN = audiobook.ISBN and" +
                "(contributor.ID = audiobook.narrator_ID or " +
                "(contributor.ID = audiobookAuthor.contributor_ID and audiobookAuthor.ISBN = audiobook.ISBN)" +
                ");";


        String restOfData = "create view q3 as select person.ID, forename, middle_initials, surname, group_concat(' ', title order by title asc) from person, boughtOwnBook where person.ID = boughtOwnBook.bobID group by person.ID order by person.ID";

        Statement makeViews = conn.createStatement();
        makeViews.execute("drop view if exists boughtOwnBook");
        makeViews.execute("drop view if exists q3");
        makeViews.execute(contributorBuysOwnBook);
        makeViews.execute(restOfData);


        PreparedStatement q = conn.prepareStatement("select * from q3");
        ResultSet id = q.executeQuery();

        while(id.next()){
            int conID = id.getInt(1);
            String forename = id.getString(2);
            String middle = id.getString(3);
            String surname = id.getString(4);
            String title = id.getString(5);
            System.out.println(conID + " " + forename + " "+ middle + " " + surname+ " " + title);

        };
        id.close();

    }

    public static void makeTables(Connection conn) throws SQLException {

        String personTable = "create table person(" +
                "ID int AUTO_INCREMENT," +
                "forename varchar(20)," +
                "middle_initials varchar(5)," +
                "surname varchar(20)," +
                "date_of_birth DATE," +
                "primary key(ID)" +
                ");";

        String contTable = "create table contributor(" +
                "ID int," +
                "biography TEXT," +
                "primary key (ID)," +
               "foreign key (ID) references person(ID)" +
                ");";

        String customerTable = "create table customer(" +
                "ID int," +
                "email_address TINYTEXT," +
                "primary key (ID)," +
                "foreign key (ID) references person(ID)" +
                ");";

        String phoneNumberTable = "create table phoneNumber (" +
                "ID int, " +
                "phone_number varchar(14)," +
                "primary key(ID, phone_number)," +
                "foreign key (ID) references customer(ID)" +
                ");";

        String publisherTable = "create table publisher ( " +
                "name varchar(50)," +
                "building varchar(20)," +
                "street varchar(20), " +
                "city varchar(20)," +
                "country varchar(20)," +
                "postcode varchar(10), " +
                "phone_number varchar(14), " +
                "established_date DATE, " +
                "primary key (name)" +
                ");";

        String audioBookTable = "create table audiobook ( " +
                "ISBN varchar(20), " +
                "title TINYTEXT, " +
                "narrator_id int," +
                "running_time TIME," +
                "age_rating int," +
                "purchase_price numeric(5, 2)," +
                "publisher_name varchar(50)," +
                "published_date DATE," +
                "audiofile BLOB," +
                "primary key(ISBN)," +
                "foreign key (narrator_id) references contributor(ID)," +
               "foreign key (publisher_name) references publisher(name)" +
                ");";

        String chapterTable = "create table chapter ( " +
                "ISBN varchar(20), " +
                "number smallint," +
                "title TINYTEXT , " +
                "start TIME ," +
                "primary key (ISBN, number)," +
                "foreign key (ISBN) references audiobook(ISBN)" +
                ");";

        String audioAuthorsTable = "create table audiobookAuthor(" +
                " contributor_ID int, " +
                " ISBN varchar(20)," +
                "primary key (contributor_ID, ISBN)," +
                "foreign key (ISBN) references audiobook(ISBN)," +
                "foreign key (contributor_ID) references contributor(ID)" +
                ") ;";

        String purchasesTable = "create table audiobookPurchase(" +
                "customer_ID int," +
                "ISBN varchar(20)," +
                "purchase_date DATETIME," +
                "primary key (customer_ID, ISBN)," +
                "foreign key (customer_ID) references customer(ID)" +
                ");";

        String reviewTable = "create table audiobookReview( " +
                "customer_ID int, " +
                "ISBN varchar(20)," +
                "rating int, " +
                "title TINYTEXT," +
                "comment TEXT, " +
                "verified BOOLEAN," +
                "primary key (customer_ID, ISBN)," +
                "foreign key (customer_ID) references customer(ID)," +
                "foreign key (ISBN) references audiobook(ISBN)" +
                ");";


        //statements used to add tables
        Statement tableMaker = conn.createStatement();

        //these are ordered so that it should be able to be deleted and recreated with this method
        tableMaker.execute("drop table if exists chapter");
        tableMaker.execute("drop table if exists audiobookAuthor");
        tableMaker.execute("drop table if exists audiobookReview");
        tableMaker.execute("drop table if exists audiobookPurchase");
        tableMaker.execute("drop table if exists phoneNumber");
        tableMaker.execute("drop table if exists customer");
        tableMaker.execute("drop table if exists audiobook");
        tableMaker.execute("drop table if exists publisher");
        tableMaker.execute("drop table if exists contributor");
        tableMaker.execute("drop table if exists person");


        tableMaker.execute(personTable);
        tableMaker.execute(contTable);
        tableMaker.execute(customerTable);
        tableMaker.execute(phoneNumberTable);
        tableMaker.execute(publisherTable);
        tableMaker.execute(audioBookTable);
        tableMaker.execute(chapterTable);
        tableMaker.execute(audioAuthorsTable);
        tableMaker.execute(purchasesTable);
        tableMaker.execute(reviewTable);
        tableMaker.close();

    }

    public static void populateFromPeople(Connection conn) throws IOException, SQLException, ParseException {
        //everyone is a person, but you must have another aspect to you to make sure

        //customers have email addresses

        //contributors have a biography

        String file = "people.csv";
        BufferedReader br = new BufferedReader(new FileReader(file));
        String splitter = "%";
        String line = "";

        while((line = br.readLine()) != null){
            String[] data = line.split(splitter);

            String forename = data[0];
            String middle = data[1];
            String surname = data[2];

            String dob = data[3];
            DateFormat format = new SimpleDateFormat("yyyy-MM-DD");
            java.util.Date birthday = format.parse(dob);
            java.sql.Date DOB = new java.sql.Date(birthday.getTime());

            String bio = data[4];

            String email = "";
            if (data.length >5){
                email = data[5];
            }

            String phone = "";
            if(data.length > 6) {
                phone = data[6];
            }


            if(email.equals("") && bio.equals("")){
                System.out.println("This was not a customer or contributor");
            }
            else{

                if(!email.equals("")){
                    PreparedStatement addCustomer = conn.prepareStatement("call addCustomer(?, ?, ?, ?, ?);");

                    addCustomer.setString(1, forename);
                    addCustomer.setString(2,middle);
                    addCustomer.setString(3,surname);
                    addCustomer.setDate(4,DOB);
                    addCustomer.setString(5,email);
                    addCustomer.execute();
                }

                if(!bio.equals("")){
                    PreparedStatement addContributor = conn.prepareStatement("call addContributor(?, ?, ?, ?, ?);");
                    addContributor.setString(1, forename);
                    addContributor.setString(2,middle);
                    addContributor.setString(3,surname);
                    addContributor.setDate(4,DOB);
                    addContributor.setString(5,bio);
                    addContributor.execute();
                }

                if(!phone.equals("")){
                    PreparedStatement getIDBack = conn.prepareStatement("select ID from person where forename = ? " +
                            "and middle_initials = ? and surname = ? and date_of_birth = ?;");

                    getIDBack.setString(1,forename);
                    getIDBack.setString(2,middle);
                    getIDBack.setString(3,surname);
                    getIDBack.setDate(4,DOB);
                    ResultSet id = getIDBack.executeQuery();

                    id.next() ;
                    int personID = id.getInt(1);
                    id.close();
                    String[] numbers = phone.split(",");
                    for (String p: numbers) {
                        PreparedStatement addPhone = conn.prepareStatement("insert into phoneNumber values (?,?)");
                        addPhone.setInt(1, personID);
                        addPhone.setString(2, p);
                        addPhone.execute();
                    }
                }
            }
        }

        br.close();
    }

    public static void populateFromPublisher(Connection conn) throws IOException, ParseException, SQLException {
        String file = "publisher.csv";
        BufferedReader br = new BufferedReader(new FileReader(file));
        String splitter = "%";
        String line = "";

        while((line = br.readLine()) != null) {
            String[] data = line.split(splitter);
            String name = data[0];
            String building = data[1];
            String street = data[2];
            String city = data[3];
            String country = data[4];
            String postcode = data[5];
            String phonenumber = data[6];
            String estDate = data[7];
            DateFormat format = new SimpleDateFormat("DD/MM/yyyy");
            java.util.Date est = format.parse(estDate);
            java.sql.Date estabilished = new java.sql.Date(est.getTime());

            PreparedStatement addPublisher = conn.prepareStatement("insert into publisher values (?,?,?,?,?,?,?,?)");

            addPublisher.setString(1,name);
            addPublisher.setString(2,building);
            addPublisher.setString(3,street);
            addPublisher.setString(4,city);
            addPublisher.setString(5,country);
            addPublisher.setString(6,postcode);
            addPublisher.setString(7,phonenumber);
            addPublisher.setDate(8,estabilished);
            addPublisher.execute();
        }

        br.close();
    }

    public static void populateFromBooks(Connection conn) throws IOException, SQLException, ParseException {

        String file = "books.tsv";
        BufferedReader br = new BufferedReader(new FileReader(file));
        String splitter = "\t";
        //needs to create an audiobook, its authors, and chapters

        String line = "";

        while((line = br.readLine()) != null){

            String[] data  = line.split(splitter);

            String isbn = data[0];
            String title = data[1];
            String narrator = data[2];
            String runTime = data[3];
            Time runningTime = Time.valueOf(runTime);

            String ageRating = data[4];
            int ageRate = 0;
            if(!ageRating.equals("")) {
                ageRate = Integer.parseInt(ageRating);
            }
            String price = data[5];
            float purchasePrice = Float.parseFloat(price);
            String publisher = data[6];

            String publishDate = data[7];
            DateFormat format = new SimpleDateFormat("yyyy-MM-DD");
            java.util.Date est = format.parse(publishDate);
            java.sql.Date published = new java.sql.Date(est.getTime());

            String chapters = data[8];
            String authors = data[9];

            PreparedStatement getNarratorID = conn.prepareStatement("select ID from person where forename = ? && surname = ?;");
            String[] narratorNames = narrator.split(" ");
            getNarratorID.setString(1,narratorNames[0]);
            getNarratorID.setString(2,narratorNames[1]);

            ResultSet id = getNarratorID.executeQuery();
            id.next() ;
            int narratorID = id.getInt(1);
            id.close();


            PreparedStatement addBook = conn.prepareStatement("insert into audiobook values (?,?,?,?,?,?,?,?,?)");
            addBook.setString(1,isbn);
            addBook.setString(2,title);
            addBook.setInt(3,narratorID);
            addBook.setTime(4,runningTime);
            addBook.setInt(5,ageRate);
            addBook.setFloat(6,purchasePrice);
            addBook.setString(7,publisher);
            addBook.setDate(8,published);
            addBook.setString(9,"");
            addBook.execute();


            if(!chapters.equals("")){
                String[] split = chapters.split(";");
                for (String chapter: split) {
                    String[] info = chapter.split(":");
                    int number = Integer.parseInt(info[0].replace(" ", ""));
                    String chapTitle = "";
                    for(int i = 1; i < info.length - 3; i++){
                        chapTitle += info[i] + ":";
                    }
                    Time startTime = Time.valueOf(info[info.length-3].replace(" ", "") + ":" + info[info.length-2].replace(" ", "") + ":" + info[info.length-1].replace(" ", ""));

                    PreparedStatement addChapter = conn.prepareStatement("insert into chapter values (?,?,?,?)");
                    addChapter.setString(1,isbn);
                    addChapter.setInt(2,number);
                    addChapter.setString(3,chapTitle);
                    addChapter.setTime(4,startTime);
                    addChapter.execute();
                }
            }

            if(!authors.equals("")){
                String[] split = authors.split(",");
                for (String author: split) {
                    PreparedStatement addAuthor = conn.prepareStatement("insert into audiobookAuthor values (?,?)");

                    PreparedStatement getAuthorID = conn.prepareStatement("select ID from person where surname = ?;");
                    String[] authorID = author.split(" ");

                    getAuthorID.setString(1, authorID[authorID.length - 1].replace("\"", "")); //normalising data as some authors have middle names

                    ResultSet auid = getAuthorID.executeQuery();
                    auid.next() ;
                    int aID = auid.getInt(1);
                    auid.close();
                    addAuthor.setInt(1,aID);
                    addAuthor.setString(2, isbn);
                    addAuthor.execute();
                }
            }
        }

        br.close();
    }

    public static void populateReviewsandPurchases(Connection conn) throws IOException, SQLException, ParseException {
        String file = "pAndr.tsv";
        BufferedReader br = new BufferedReader(new FileReader(file));
        String splitter = "\t";
        String line = "";

        while((line = br.readLine()) != null){
            String[] data = line.split(splitter);
            String title = data[0];

            String purchases = "";
            if(data.length > 1) {
                purchases = data[1];
            }
            String reviews = "";
            if(data.length > 2) {
                reviews = data[2];
            }

            if(!purchases.equals("")){
                String[] allPurchases = purchases.split(";");
                for (String purchase: allPurchases) {

                    PreparedStatement getIDBack = conn.prepareStatement("select ID from person where forename = ? and surname = ?;");
                    String[] firstSplit = purchase.split(" at ");
                    firstSplit[0] = firstSplit[0].replace("\"","").replace("  ", "");
                    String[] names = firstSplit[0].split(" ");
                    getIDBack.setString(1, names[0]);
                    getIDBack.setString(2, names[names.length - 1]);
                    ResultSet id = getIDBack.executeQuery();
                    id.next();
                    int personID = id.getInt(1);
                    id.close();


                    PreparedStatement getISBN = conn.prepareStatement("select ISBN from audiobook where title = ?;");

                    getISBN.setString(1, title);
                    ResultSet isbn = getISBN.executeQuery();
                    isbn.next();
                    String ISBN = isbn.getString(1);
                    isbn.close();

                    try {

                        PreparedStatement addPurchase = conn.prepareStatement("insert into audiobookPurchase values (?,?,?)");
                        addPurchase.setInt(1, personID);
                        addPurchase.setString(2, ISBN);
                        DateFormat format = new SimpleDateFormat("yyyy-MM-DD HH:MM:SS");
                        java.util.Date purchaseDate = format.parse(firstSplit[1]);
                        java.sql.Date pd = new java.sql.Date(purchaseDate.getTime());
                        addPurchase.setDate(3, pd);
                        addPurchase.execute();
                    }
                    catch (SQLException e){
                        System.out.println(e.getSQLState());
                    }

                }

            }

            if(!reviews.equals("")){
                String[] allreviews = reviews.split(";");
                for (String review: allreviews) {

                    int nameIndex = (review.indexOf(","));
                    String name = review.substring(0,nameIndex);
                    name = name.replace("  ", "");
                    String[] nameSplit = name.split(" ");
                    PreparedStatement getIDBack = conn.prepareStatement("select ID from person where forename = ? and surname = ?;"); //TODO : refactor this into a method
                    getIDBack.setString(1, nameSplit[0]);
                    getIDBack.setString(2,nameSplit[nameSplit.length - 1]);

                    ResultSet id = getIDBack.executeQuery();
                    id.next();
                    int personID = id.getInt(1);
                    id.close();

                    PreparedStatement getISBN = conn.prepareStatement("select ISBN from audiobook where title = ?;");//TODO : refactor this into a method
                    getISBN.setString(1, title);
                    ResultSet gISBN = getISBN.executeQuery();
                    gISBN.next();
                    String ISBN = gISBN.getString(1);



                    String rateNum = review.substring(nameIndex+1, review.indexOf(":"));
                    rateNum = rateNum.replaceAll("[A-Za-z]","").replaceAll(" ","");
                    int rating = Integer.parseInt(rateNum);

                    String comment = review.substring(review.indexOf(":") + 1);

                    PreparedStatement verify = conn.prepareStatement("select ISBN from audiobookPurchase where  customer_ID = ? and ISBN = ?;");
                    verify.setInt(1,personID);
                    verify.setString(2,ISBN);
                    ResultSet v = verify.executeQuery();
                    boolean validReview = false;
                    if(v.next()){
                        validReview = true;
                    }

                    PreparedStatement addReview = conn.prepareStatement("insert into audiobookReview values (?,?,?,?,?,?)");
                    addReview.setInt(1, personID);
                    addReview.setString(2, ISBN);
                    addReview.setInt(3,rating);
                    addReview.setString(4,title);
                    addReview.setString(5,comment);
                    addReview.setBoolean(6,validReview);
                    addReview.execute();

                }
            }


        }

        br.close();
    }

    public static void setUpPassword(Connection conn) throws SQLException {
        Statement tableMaker = conn.createStatement();
        tableMaker.execute("drop table if exists login");

        String loginTable = "create table login( " +
                "username varchar(30)," +
                "password varchar(50)," +
                "primary key (username)" +
                ");";

        tableMaker.execute(loginTable);
        tableMaker.execute("insert into login values ('hello', 'THOMJ67P1ifC71HVxFqvVlR/IeY=')");
    }


}
