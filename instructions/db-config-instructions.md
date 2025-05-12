# Database Configuration

## Development Environment Configuration

For development, the application uses a direct connection pool configured in `DatabaseUtil.java`. You can modify the following configuration parameters according to your MySQL setup:

```java
// in src/main/java/com/streamflix/util/DatabaseUtil.java
private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
private static final String DB_URL = "jdbc:mysql://localhost:3306/streamflix";
private static final String DB_USERNAME = "streamflix_user";
private static final String DB_PASSWORD = "streamflix_password";
```

Change these values to match your MySQL database configuration:
- `DB_URL`: The JDBC URL for your MySQL database. The format is typically `jdbc:mysql://[host]:[port]/[database_name]`
- `DB_USERNAME`: Your MySQL username
- `DB_PASSWORD`: Your MySQL password

## Production Environment Configuration (JNDI)

For production deployment, it's recommended to use JNDI (Java Naming and Directory Interface) to manage the database connection pool through your application server. This approach separates the configuration from the code and provides better management of database connections.

### Steps to Configure JNDI in Tomcat:

1. Modify the `context.xml` file in the Tomcat's conf directory or add a context.xml file in your application's META-INF directory:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <Resource name="jdbc/streamflix" 
              auth="Container" 
              type="javax.sql.DataSource"
              maxTotal="100" 
              maxIdle="30" 
              maxWaitMillis="10000"
              username="your_mysql_username" 
              password="your_mysql_password" 
              driverClassName="com.mysql.cj.jdbc.Driver"
              url="jdbc:mysql://your_mysql_host:3306/streamflix?useSSL=false&amp;serverTimezone=UTC"/>
</Context>
```

2. Make sure the MySQL Connector/J JAR file is in Tomcat's lib directory.

3. The application is already configured to try JNDI first, falling back to the direct connection pool if JNDI is not available.

## Database Setup

1. Create a new MySQL database:

```sql
CREATE DATABASE streamflix;
```

2. Create a database user and grant privileges:

```sql
CREATE USER 'streamflix_user'@'localhost' IDENTIFIED BY 'streamflix_password';
GRANT ALL PRIVILEGES ON streamflix.* TO 'streamflix_user'@'localhost';
FLUSH PRIVILEGES;
```

3. Run the database script to create the schema and populate it with sample data:

```bash
mysql -u streamflix_user -p streamflix < database-script.sql
```

## Connection Pool Settings

The connection pool is configured with the following parameters:

- Initial Size: 5 connections
- Maximum Total: 20 connections
- Maximum Idle: 10 connections
- Minimum Idle: 5 connections
- Maximum Wait: 10000 milliseconds

You can adjust these values in `DatabaseUtil.java` based on your application's needs and server resources.
