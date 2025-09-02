# Cryptography

---

## Table of Contents
1. Prerequisites & Core Concepts  
2. Encoding & Data Formats  
3. Hashing, HMAC, & Key Derivation (HKDF, PBKDF2/Argon2)  
4. Symmetric Encryption (AES and AES-GCM)  
5. Asymmetric Encryption (RSA/ECC) & Differences  
6. Key Exchange (Diffie-Hellman/ECDH)  
7. Digital Signatures (ECDSA)  

---

## Chapter 1: Prerequisites & Core Concepts
1. Goals of Cryptography  
Cryptography exists to protect information. The four main goals are often summarized:  
 • Confidentiality → Keep data secret from unauthorized parties (achieved with encryption).  
 • Integrity → Ensure data is not modified in transit (achieved with hashes, MACs, or signatures).  
 • Authentication → Verify the identity of the sender or receiver (achieved with digital signatures, certificates).  
 • Non-repudiation → Prevent someone from denying that they sent a message (achieved with digital signatures).

2. Core Terminology  
 • Plaintext: The original readable message.  
 • Ciphertext: The scrambled message after encryption.  
 • Key: A secret value controlling encryption/decryption.  
 • Algorithm (Cipher): The mathematical recipe for transforming plaintext into ciphertext (and back).  

⚠️ Important Note: Even strong algorithms fail if keys are weak, reused, or poorly protected. Key management is as important as the math.

## Chapter 2: Encoding & Data Formats (Base64, Hex, URL-safe)
- Encoding represents data in a transport or display-friendly format. It does not add confidentiality or integrity.  
- Common choices:  
  - UTF-8 for text → `String` ↔ `Data`  
  - Base64 for compact, binary-to-ASCII-safe serialization (increases size by ~33%, widely used standard)  
  - Hex encoding (increases size by ~100%)

Swift examples:  
```swift
import Foundation

// String ⇄ Data (UTF-8)
let text = "hello"
let data = Data(text.utf8)
let textBack = String(data: data, encoding: .utf8)!

// Base64 (standard)
let base64 = data.base64EncodedString()            // aGVsbG8=
let decoded = Data(base64Encoded: base64)!

// Hex encode
func hexEncodedString(_ data: Data) -> String {
    data.map { String(format: "%02x", $0) }.joined()
}
let hex = hexEncodedString(data)                   // 68656c6c6f
```

---

## Chapter 3: Hashing, HMAC, KDF
- SHA-256 for integrity  
- HMAC for authenticity  
- HKDF for deriving session keys  

### Hashing basics  
- Cryptographic hashes are deterministic, one-way, and collision-resistant within practical limits.  
- Use cases: file integrity, message digests, commitment schemes, key fingerprints.  
- On CryptoKit use `SHA256`, `SHA384`, or `SHA512`. Avoid legacy SHA-1.

Swift – compute digests:  
```swift
import CryptoKit
import Foundation

let message = Data("Important payload".utf8)
let digest256 = SHA256.hash(data: message)   // 32 bytes
let digest512 = SHA512.hash(data: message)   // 64 bytes

// Convert digest to hex string for logging or display
let hexDigest = digest256.map { String(format: "%02x", $0) }.joined()
```

### HMAC for integrity + authenticity  
- HMAC binds data to a secret key; verify on the receiver to detect tampering and spoofing.  
- Choose `HMAC<SHA256>` for most applications. Keys must be random and secret.

Swift – HMAC tag:  
```swift
import CryptoKit

let macKey = SymmetricKey(size: .bits256)
let mac = HMAC<SHA256>.authenticationCode(for: message, using: macKey)
let macData = Data(mac)

// Verify (constant-time)
let isValid = HMAC<SHA256>.isValidAuthenticationCode(mac, authenticating: message, using: macKey)
```

---

## Chapter 4: Symmetric Encryption (AES and AES-GCM)

Symmetric encryption is a fundamental cryptographic technique where the same secret key is used for both encrypting and decrypting data. Because both parties share the same key, symmetric encryption is generally much faster than asymmetric methods, making it suitable for encrypting large volumes of data efficiently. This speed and simplicity make symmetric encryption the backbone of most secure communication channels and data storage systems.

### Key Characteristics of Symmetric Encryption
- **Shared Secret Key:** Both sender and receiver must have access to the same secret key, which must be kept confidential.  
- **High Performance:** Symmetric algorithms are computationally efficient, ideal for real-time or bulk data encryption.  
- **Use Cases:** Commonly used for encrypting files, network traffic, session data, and database entries.

### Advantages and Disadvantages

| Advantages                          | Disadvantages                               |
|-----------------------------------|---------------------------------------------|
| Fast encryption and decryption    | Key distribution problem: securely sharing keys is challenging |
| Suitable for large data volumes   | If key is compromised, all data is at risk |
| Well-studied and widely supported | No built-in authentication or integrity guarantee (unless combined with MAC/AEAD) |

### Understanding AES (Advanced Encryption Standard)

AES is the most widely adopted symmetric encryption algorithm in the world. Established by the U.S. National Institute of Standards and Technology (NIST) in 2001, it replaced the older DES (Data Encryption Standard) and has become the de facto standard for secure data encryption.

#### What Makes AES Special
- **Government Standard:** Approved by NIST for U.S. government use and widely adopted globally
- **Block Cipher:** Processes data in fixed 128-bit blocks through multiple rounds of encryption
- **Three Key Sizes:** AES-128 (10 rounds), AES-192 (12 rounds), AES-256 (14 rounds)
- **Hardware Acceleration:** Modern processors include dedicated AES instructions for high performance

#### AES Key Sizes and Security
| Key Size | Rounds | Security Level | Use Case |
|----------|--------|----------------|----------|
| AES-128  | 10     | 128 bits       | General purpose, most applications |
| AES-192  | 12     | 192 bits       | Enhanced security requirements |
| AES-256  | 14     | 256 bits       | Government, financial, highest security |

### AEAD: Why Authenticated Encryption Matters

Modern symmetric encryption schemes often use AEAD (Authenticated Encryption with Associated Data) modes, which provide both confidentiality and integrity in a single operation. This means the data is not only encrypted but also protected from tampering or forgery.

### AES-GCM: The Gold Standard for Authenticated Encryption

AES-GCM (Galois/Counter Mode) is the most widely used AEAD mode that combines AES encryption with authentication. It's the preferred choice for most modern applications due to its security, performance, and widespread support.

#### How AES-GCM Works
1. **Nonce Generation:** Generate a unique 96-bit nonce (number used once) for each encryption operation
2. **Counter Initialization:** Initialize a 32-bit counter starting at 1, combined with the nonce to form a 128-bit counter block
3. **Keystream Generation:** Use AES to encrypt the counter block, incrementing the counter for each block of plaintext
4. **Plaintext Encryption:** XOR the generated keystream with the plaintext to produce ciphertext
5. **GHASH Authentication:** Compute the GHASH function over the ciphertext, associated data, and length information using multiplication in GF(2^128)
6. **Final Authentication:** XOR the GHASH result with the encrypted counter (using counter value 0) to produce the 128-bit authentication tag
7. **Output Assembly:** Combine ciphertext + authentication tag + nonce into the final output

```
Plain: 1011
Key:   1100
------------
Cipher:0111

Cipher: 0111
Key:    1100
------------
Plain:  1011 
```

#### Key Components of AES-GCM
- **Nonce (IV):** A unique random number for each encryption operation
- **Authentication Tag:** 128-bit tag that verifies data integrity and authenticity
- **Associated Data:** Optional data that's authenticated but not encrypted
- **Ciphertext:** The encrypted data
  
Important: Never reuse the same nonce with the same key. Nonce reuse in GCM catastrophically breaks security.

### Typical iOS Use Cases for AES-GCM
- **Local Data Encryption:** Securing user files, preferences, and sensitive app data
- **Network Security:** TLS connections commonly use AES-GCM for secure communication
- **Keychain Protection:** Keychain items are encrypted with strong AES-based protection; exact modes can vary by OS version
- **Secure Enclave:** Hardware-backed key storage and elliptic-curve operations; AES itself is accelerated by CPU instructions
- **App-to-App Communication:** Encrypting data shared between apps
- **Cloud Storage:** Encrypting data before uploading to cloud services

### Swift Examples – AES-GCM Implementation

#### Basic AES-GCM Encryption and Decryption
```swift
import CryptoKit

// Generate a random 256-bit symmetric key
let key = SymmetricKey(size: .bits256)

// Prepare plaintext data
let plaintext = Data("Secret message".utf8)

// Encrypt the plaintext using AES-GCM
let sealed = try AES.GCM.seal(plaintext, using: key)

// Extract the combined encrypted data (ciphertext + tag + nonce)
let combined = sealed.combined!

// To decrypt, create a sealed box from the combined data
let box = try AES.GCM.SealedBox(combined: combined)

// Decrypt the data using the same key
let decrypted = try AES.GCM.open(box, using: key)
```

#### AES-GCM with Associated Data (AAD)
```swift
// Encrypt with associated data that's authenticated but not encrypted
let plaintext = Data("Sensitive user data".utf8)
let associatedData = Data("User ID: 12345".utf8)

let sealed = try AES.GCM.seal(plaintext, using: key, nonce: AES.GCM.Nonce(), authenticating: associatedData)

// Decrypt with the same associated data
let decrypted = try AES.GCM.open(sealed, using: key, authenticating: associatedData)
```
---

## Chapter 5: Asymmetric Encryption (RSA/ECC) & Differences

Asymmetric encryption, also known as public-key cryptography, uses a pair of keys: a public key for encryption or signature verification, and a private key for decryption or signing. Unlike symmetric encryption, the keys are different but mathematically related, enabling secure communication without the need to share a secret key in advance.

### Core Idea of Asymmetric Cryptography
- **Public Key:** Can be freely distributed and used to encrypt data or verify signatures.  
- **Private Key:** Must be kept secret and is used to decrypt data or create digital signatures.  
- This separation simplifies key distribution and supports digital identity verification.

### RSA: The Traditional Workhorse
RSA is one of the earliest and most widely used asymmetric algorithms. It relies on the mathematical difficulty of factoring large composite numbers.

- **Key Size:** Typically 2048 bits or larger for adequate security.  
- **Performance:** Computationally intensive and slower compared to symmetric algorithms, especially for large data.  
- **Compatibility:** Supported almost universally, making it a common choice for legacy systems and interoperability.  
- **Use Cases:** Digital signatures, key exchange, and encrypting small amounts of data.

### ECC: Modern, Efficient Public-Key Cryptography
Elliptic Curve Cryptography (ECC) offers the same security level as RSA but with much smaller key sizes and faster computations. This efficiency makes ECC ideal for resource-constrained devices like smartphones.

- **Key Size:** For example, a 256-bit ECC key offers comparable security to a 3072-bit RSA key.  
- **Performance:** Faster key generation, signing, and verification.  
- **Security:** Based on the hardness of the elliptic curve discrete logarithm problem.  
- **Use Cases:** Secure Enclave operations, TLS certificates, and modern cryptographic protocols.

### RSA vs ECC Comparison

| Feature           | RSA                         | ECC                         |
|-------------------|-----------------------------|-----------------------------|
| Key Size          | Large (2048+ bits)           | Small (256-521 bits)         |
| Speed             | Slower                      | Faster                      |
| Resource Usage    | Higher CPU and memory        | Lower CPU and memory         |
| Security Level    | Based on factoring problem   | Based on elliptic curve problem |
| Usage             | Legacy systems, compatibility | TLS 1.3, Secure Enclave, blockchains |

### Practical Usage Scenarios
- **RSA:**  
 - Widely used in older systems and software that require broad compatibility.  
 - Often used for digital signatures and certificate authorities.  
- **ECC:**  
 - Preferred in modern mobile and embedded systems due to efficiency.  
 - Used extensively in Apple's Secure Enclave, TLS 1.3, and many blockchain technologies.

### How Secure Communication Works: 5 Simple Steps

Think of secure communication like two people agreeing on a secret code, then using it to send private messages that can't be read or tampered with by anyone else.

#### Step 1: Agree on a Secret Code (Key Exchange)
- **What happens:**  
Two devices (like your phone and a server) agree on a secret number without actually sending it over the internet.
- **How:**  
Each device creates its own private and public keys, shares the public keys, and then both compute the same secret number using math.
- **Result:**  
Both devices now know the same secret number, but it was never sent over the network.

#### Step 2: Create Different Keys for Different Jobs (Key Derivation)
- **What happens:**  
Turn that one secret number into multiple specialized keys for different purposes.
- **How:**  
Use a special function (HKDF) to create separate keys for:
- Encrypting messages from client to server
- Encrypting messages from server to client  
- Creating unique numbers for each message
- **Result:**  
Multiple keys ready for different tasks.

#### Step 3: Encrypt the Messages (Encryption)
- **What happens:**  
Turn readable messages into unreadable gibberish.
- **How:**  
Use AES-GCM to scramble each message with its own unique number (nonce).
- **Result:**  
Encrypted message + a special tag that proves it's authentic.

#### Step 4: Verify the Message is Real (Authentication)
- **What happens:**  
Check that the message really came from the right person and wasn't changed.
- **How:**  
Verify the authentication tag and check that the message hasn't been tampered with.
- **Result:**  
Either accept the message as genuine or reject it as fake.

#### Step 5: Keep Talking Securely (Ongoing Communication)
- **What happens:**  
Continue sending encrypted messages back and forth safely.
- **How:**  
For each message:
- Use a new unique number
- Encrypt the message
- Send it with its authentication tag
- Change keys periodically for extra security
- **Result:**  
A secure conversation that protects your privacy and data integrity.

#### Swift Example: Implementing the 5 Steps
```swift
import CryptoKit
import Foundation

// Step 1: Key Exchange (ECDH)
func establishSecureConnection() throws -> (clientToServer: SymmetricKey, serverToClient: SymmetricKey) {
    // Client generates key pair
    let clientPrivateKey = P256.KeyAgreement.PrivateKey()
    let clientPublicKey = clientPrivateKey.publicKey
    
    // Server generates key pair (in real app, this would be on server)
    let serverPrivateKey = P256.KeyAgreement.PrivateKey()
    let serverPublicKey = serverPrivateKey.publicKey
    
    // Both compute shared secret
    let clientSharedSecret = try clientPrivateKey.sharedSecretFromKeyAgreement(with: serverPublicKey)
    let serverSharedSecret = try serverPrivateKey.sharedSecretFromKeyAgreement(with: clientPublicKey)
    
    // Step 2: Key Derivation (HKDF)
    // Derive distinct keys per direction
    let clientToServer = clientSharedSecret.hkdfDerivedSymmetricKey(
        using: SHA256.self,
        salt: "TLS1.3".data(using: .utf8)!,
        sharedInfo: "client_to_server".data(using: .utf8)!,
        outputByteCount: 32
    )
    
    let serverToClient = serverSharedSecret.hkdfDerivedSymmetricKey(
        using: SHA256.self,
        salt: "TLS1.3".data(using: .utf8)!,
        sharedInfo: "server_to_client".data(using: .utf8)!,
        outputByteCount: 32
    )
    
    return (clientToServer, serverToClient)
}

// Step 3 & 4: Encrypt and Authenticate
func encryptMessage(_ message: String, using key: SymmetricKey) throws -> Data {
    let messageData = Data(message.utf8)
    
    // Encrypt with AES-GCM (provides both encryption and authentication)
    let sealedBox = try AES.GCM.seal(messageData, using: key)
    
    // Returns ciphertext + authentication tag + nonce
    return sealedBox.combined!
}

// Step 5: Decrypt and Verify
func decryptMessage(_ encryptedData: Data, using key: SymmetricKey) throws -> String {
    // Create sealed box from combined data
    let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
    
    // Decrypt and verify authentication tag
    let decryptedData = try AES.GCM.open(sealedBox, using: key)
    
    return String(data: decryptedData, encoding: .utf8)!
}

// Complete Example Usage
func secureCommunicationExample() {
    do {
        // Step 1 & 2: Establish connection and derive directional keys
        let keys = try establishSecureConnection()
        
        // Step 3 & 4: Client encrypts message
        let originalMessage = "Hello, secure world!"
        // Use the client->server key for this example
        let encryptedMessage = try encryptMessage(originalMessage, using: keys.clientToServer)
        
        // Step 5: Server decrypts and verifies message
        let decryptedMessage = try decryptMessage(encryptedMessage, using: keys.clientToServer)
        
        print("Original: \(originalMessage)")
        print("Decrypted: \(decryptedMessage)")
        print("Messages match: \(originalMessage == decryptedMessage)")
        
    } catch {
        print("Error: \(error)")
    }
}
```

This example shows:
- **Step 1:** ECDH key exchange between client and server
- **Step 2:** HKDF key derivation to create session keys
- **Step 3:** AES-GCM encryption of messages
- **Step 4:** Automatic authentication through GCM's authentication tag
- **Step 5:** Secure message exchange with verification

---

## Chapter 6: Key Exchange with Diffie-Hellman

Key exchange is the foundation of secure communication. It allows two parties to establish a shared secret over an insecure channel without ever transmitting the secret itself. This chapter explains both traditional Diffie-Hellman and its modern elliptic curve variant.

### The Key Exchange Problem

Imagine two people, Alice and Bob, want to communicate secretly over a public channel that anyone can eavesdrop on. They need to agree on a secret key, but they can't just send it directly because an eavesdropper would see it.

**The Challenge:** How do Alice and Bob establish a shared secret when everything they send can be intercepted?

### Traditional Diffie-Hellman (DH)

Traditional Diffie-Hellman uses modular arithmetic with large prime numbers. Here's how it works:

#### Mathematical Foundation
- **Prime Modulus (p):** A large prime number (typically 2048+ bits)
- **Generator (g):** A primitive root modulo p
- **Private Keys:** Each party chooses a random private key (a, b)
- **Public Keys:** Each party computes their public key: g^a mod p and g^b mod p

#### The Key Exchange Process
1. **Setup:** Alice and Bob agree on a prime p and generator g (publicly known)
2. **Private Key Generation:** 
   - Alice chooses private key a
   - Bob chooses private key b
3. **Public Key Exchange:**
   - Alice computes A = g^a mod p and sends it to Bob
   - Bob computes B = g^b mod p and sends it to Alice
4. **Shared Secret Computation:**
   - Alice computes: B^a mod p = (g^b)^a mod p = g^(ab) mod p
   - Bob computes: A^b mod p = (g^a)^b mod p = g^(ab) mod p
5. **Result:** Both arrive at the same shared secret: g^(ab) mod p

#### Security Basis
The security relies on the **Discrete Logarithm Problem:** Given g, p, and g^x mod p, it's computationally infeasible to find x.

---

## Chapter 7: Digital Signatures

Digital signatures provide authentication, integrity, and non-repudiation. They prove that a message came from a specific sender and hasn't been altered.

### How Digital Signatures Work

1. **Signing:** Use private key to create a signature from a message
2. **Verification:** Use public key to verify the signature is valid
3. **Security:** Only the private key holder can create valid signatures

### ECDSA (Elliptic Curve Digital Signature Algorithm)

#### Swift Example
```swift
import CryptoKit

// Generate key pair
let privateKey = P256.Signing.PrivateKey()
let publicKey = privateKey.publicKey

// Sign a message
let message = Data("Hello, World!".utf8)
let signature = try privateKey.signature(for: message)

// Verify signature
let isValid = publicKey.isValidSignature(signature, for: message)
print("Signature valid: \(isValid)")
```

### Use Cases

- **App Updates:** Verify update authenticity
- **JWT Tokens:** Sign and verify authentication tokens
- **Blockchain:** Cryptocurrency transactions
- **Code Signing:** Verify app integrity
- **Secure Communication:** Message authentication

### Security Benefits

- **Authentication:** Proves message origin
- **Integrity:** Detects message tampering
- **Non-repudiation:** Sender cannot deny sending
- **Public Verification:** Anyone can verify with public key

---

## Appendix: SSH with Public‑Key Cryptography (macOS)

SSH uses asymmetric keys (e.g., RSA) to authenticate without passwords. This is a practical application of Chapters 5 and 7.

### Generate an RSA key pair
```bash
ssh-keygen -t rsa -b 4096 -C "you@example.com"
```

### Install your public key on a server
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@server_ip -p server_port
```

### Quick connect
```bash
ssh user@server.example.com
```

---