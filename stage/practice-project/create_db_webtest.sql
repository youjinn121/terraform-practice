CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES ('Admin', 'jeonyjdbwls0901@gmail.com');
INSERT INTO users (name, email) VALUES ('Terraform-User', 'terraform@eks.com');
