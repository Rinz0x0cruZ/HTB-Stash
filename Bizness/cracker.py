import hashlib
import base64
import os
from tqdm import tqdm

class PasswordEncryptor:
    def __init__(self, hash_type="SHA256", pbkdf2_iterations=10000):
        self.hash_type = hash_type
        self.pbkdf2_iterations = pbkdf2_iterations

    def crypt_bytes(self, salt, value):
        if not salt:
            salt = base64.urlsafe_b64encode(os.urandom(16)).decode('utf-8')
        try:
            hash_obj = hashlib.pbkdf2_hmac(self.hash_type, value, salt.encode('utf-8'), self.pbkdf2_iterations)
            result = f"${self.hash_type}${salt}${base64.urlsafe_b64encode(hash_obj).decode('utf-8').replace('+', '.')}"
            return result
        except Exception as e:
            raise Exception(f"Error while computing hash: {e}")

    def get_crypted_bytes(self, salt, value):
        try:
            hash_obj = hashlib.pbkdf2_hmac(self.hash_type, value, salt.encode('utf-8'), self.pbkdf2_iterations)
            return base64.urlsafe_b64encode(hash_obj).decode('utf-8').replace('+', '.')
        except Exception as e:
            raise Exception(f"Error while computing hash: {e}")

# Example usage:
hash_type = "SHA256"
salt = "d"
search = "$SHA256$d$uP0_QaVBpDWFeo8-dRzDqRwXQ2IYNN"
wordlist = '/usr/share/wordlists/rockyou.txt'

encryptor = PasswordEncryptor(hash_type)

total_lines = sum(1 for _ in open(wordlist, 'r',encoding='latin-1'))

with open(wordlist, 'r', encoding='utf-8') as password_list:
    for password in tqdm(password_list, total=total_lines, desc="Processing"):
        value = password.strip()

        hashed_password = encryptor.crypt_bytes(salt, value.encode('utf-8'))

        if hashed_password.lower() == search.lower():
            print(f'Found Password: {value}, hash: {hashed_password}')
            break
