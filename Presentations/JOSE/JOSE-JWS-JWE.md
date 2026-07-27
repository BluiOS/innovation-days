## Contents

1. [JOSE](#jose)
2. [The communication problem without JOSE](#the-communication-problem-without-jose)
3. [The JOSE solution](#the-jose-solution)
4. [The family in one table](#the-family-in-one-table)
5. [Shared JOSE ideas](#shared-jose-ideas)
6. [JWS](#jws-what-problem-does-it-solve)
7. [JWA: JSON Web Algorithms](#jwa-json-web-algorithms)
8. [JWT](#jwt-json-web-token)
9. [JWK: JSON Web Key](#jwk-json-web-key)
10. [JWKS: JSON Web Key Set](#jwks-json-web-key-set)
11. [JWE: JSON Web Encryption](#jwe-json-web-encryption)
12. [JWS versus JWE](#jws-versus-jwe)
13. [Primary references](#primary-references-for-further-study)
---
# JOSE

**JOSE is a set of standards for packaging signed or encrypted data so different systems can exchange and understand it.**

## Five words we need first

| Word | Brief definition | Example |
|---|---|---|
| **Claim** | One statement represented by a name and value | `"amount": 100000` |
| **Payload** | The complete data we want to protect | `{"amount":100000,"destination":"account-123"}` |
| **Signing** | Creates evidence that protected data was not changed and was produced by a signing-key holder | Sign the payment payload and send its signature |
| **Encryption** | Transforms readable plaintext into ciphertext so it cannot be read without the decryption key | Encrypt the payment payload before sending it |
| **Cryptographic key** | Data used by a cryptographic algorithm to sign, verify, encrypt, or decrypt | An HMAC secret or a P-256 private/public key pair |

In this example:

```json
{
  "amount": 100000,
  "destination": "account-123"
}
```

- `amount` and `destination` are individual claims.
- The complete JSON object is the payload.
- Signing keeps the payload readable but lets the receiver detect modification.
- Encryption hides the payload from anyone who does not have the required key.

References: [RFC 7519 §2 — Claim and Claims Set](https://www.rfc-editor.org/rfc/rfc7519.html#section-2), [RFC 7515 §2 — Payload and Signature](https://www.rfc-editor.org/rfc/rfc7515.html#section-2), [RFC 7516 §2 — Plaintext and Ciphertext](https://www.rfc-editor.org/rfc/rfc7516.html#section-2).

---

## The communication problem without JOSE

Suppose the iOS app signs the payment payload and sends it to the backend:

```json
{
  "amount": 100000,
  "destination": "account-123"
}
```

The signing algorithm produces signature bytes, but the algorithm alone does not define how the complete message should be exchanged. The backend still needs answers:

- Which signature algorithm did the app use?
- Which key should verify the signature?
- Which exact payload bytes were signed?
- How are binary signature bytes represented in HTTP or JSON?

#### JOSE gives teams a standard format for exchanging signed or encrypted data.

---

## The JOSE solution

**JOSE**—pronounced “Ho-zay”—stands for **JSON Object Signing and Encryption**.

JOSE is a family of standards for packaging signed or encrypted data so different systems can exchange and process it consistently.

JOSE standardizes the message format. It does not automatically establish key trust.

References: [RFC 7515 §§3 and 7.1 — JWS](https://www.rfc-editor.org/rfc/rfc7515.html#section-3), [RFC 7516 — JWE](https://www.rfc-editor.org/rfc/rfc7516.html), [RFC 7517 — JWK](https://www.rfc-editor.org/rfc/rfc7517.html), [RFC 7518 — JWA](https://www.rfc-editor.org/rfc/rfc7518.html).

---

## The family in one table

JOSE is a family containing several related standards:

| Family member | Standard |
|---|---|
| JWS | RFC 7515 |
| JWE | RFC 7516 |
| JWK / JWKS | RFC 7517 |
| JWA | RFC 7518 |
| JWT | RFC 7519 |

We will examine what each one means and how they relate.

References: [RFC 7515](https://www.rfc-editor.org/rfc/rfc7515.html), [RFC 7516](https://www.rfc-editor.org/rfc/rfc7516.html), [RFC 7517](https://www.rfc-editor.org/rfc/rfc7517.html), [RFC 7518](https://www.rfc-editor.org/rfc/rfc7518.html), [RFC 7519](https://www.rfc-editor.org/rfc/rfc7519.html).

---

## Shared JOSE ideas

The standards reuse a small set of concepts:

| Concept | Meaning | example |
|---|---|---|
| JOSE Header | Describes the cryptographic operation | `{"alg":"ES256","kid":"payment-key-1"}` |
| Protected header | Header covered by the signature or encryption authentication | Changing `alg` makes verification fail |
| Unprotected header | Visible header not covered by that protection | A non-security-critical display hint |
| Payload / plaintext | Application data being signed or encrypted | `{"amount":100000}` |
| Base64URL | Converts bytes to URL-safe text; it is not encryption | `{"amount":100000}` → `eyJhbW91bnQiOjEwMDAwMH0` |
| Compact serialization | Joins encoded parts with dots | JWS: `header.payload.signature` |
| JSON serialization | Represents the JOSE parts as fields in a JSON object | `{"protected":"eyJhbGciOiJFUzI1NiJ9","payload":"eyJhbW91bnQiOjEwMDAwMH0","signature":"YWJjMTIz"}` |
| Profile | A profile is an agreed contract between the producer and consumer, such as the iOS client and backend. | Accept only `ES256`; require `kid`, `aud`, and `exp` |

References: [RFC 7515 §§2–3](https://www.rfc-editor.org/rfc/rfc7515.html#section-2), [RFC 7516 §§2–3](https://www.rfc-editor.org/rfc/rfc7516.html#section-2), [RFC 8725 §3](https://www.rfc-editor.org/rfc/rfc8725.html#section-3).

---

## JWS: what problem does it solve?

**JWS** stands for **JSON Web Signature**. It defines how to package application data together with a digital signature or MAC.

We will use one payment payload throughout this section:

```json
{
  "amount": 100000,
  "destination": "account-123"
}
```

JWS can let the receiver determine that:

- the protected data was not modified; and
- someone holding the required signing or MAC key produced the protection.

JWS does **not** hide the payload. Base64URL is reversible, so anyone who receives a normal compact JWS can decode its header and payload. Use JWE when confidentiality is required.

References: [RFC 7515 §§1 and 3](https://www.rfc-editor.org/rfc/rfc7515.html#section-1), [RFC 7516 §1](https://www.rfc-editor.org/rfc/rfc7516.html#section-1).

---

## Step 1 — understand the three JWS parts

| Part | Purpose | Payment example |
|---|---|---|
| JOSE header | Describes how the data is protected | `{"alg":"HS256","kid":"payment-key-1"}` |
| Payload | The application bytes being protected | `{"amount":100000,"destination":"account-123"}` |
| Signature or MAC | Cryptographic result calculated over the protected header and payload | 32 HMAC-SHA-256 bytes |

The header does not make security decisions by itself:

- `alg: HS256` says the producer used HMAC-SHA-256.
- `kid: payment-key-1` helps the receiver locate a candidate key.

Reference: [RFC 7515 §§2–3 and 4.1](https://www.rfc-editor.org/rfc/rfc7515.html#section-3).

---

## Step 2 — choose a JWS serialization

The same logical JWS can be represented in three standard forms:

| Serialization | Shape | Signatures | When it is useful |
|---|---|---:|---|
| Compact | `header.payload.signature` | One | Short text for HTTP headers or request fields |
| Flattened JSON | One JSON object | One | Named fields and optional unprotected header |
| General JSON | JSON with a `signatures` array | Many | Multiple signers protect the same payload |

Flattened JSON example:

```json
{
  "protected": "eyJhbGciOiJIUzI1NiIsImtpZCI6InBheW1lbnQta2V5LTEifQ",
  "payload": "eyJhbW91bnQiOjEwMDAwMCwiZGVzdGluYXRpb24iOiJhY2NvdW50LTEyMyJ9",
  "signature": "Dwd8-NpRCCC8E1FodDCkI1ugNKAmCnler90B253rOCY"
}
```

References: [RFC 7515 §§7.1–7.2](https://www.rfc-editor.org/rfc/rfc7515.html#section-7)
---

## Step 3 — read one compact JWS

Sample:

| Position | Decode result |
|---:|---|
| 1 | Header: `{"alg":"HS256","kid":"payment-key-1"}` |
| 2 | Payload: `{"amount":100000,"destination":"account-123"}` |
| 3 | Binary HMAC value—not JSON |

Decoding parts 1 and 2 only reveals their contents. It does **not** prove that the JWS is authentic.

Reference: [RFC 7515 §§3.1 and 7.1](https://www.rfc-editor.org/rfc/rfc7515.html#section-3.1).

---

## Step 4 — encode the parts and create the signing input

JWS compact serialization converts the header and payload bytes to Base64URL:

```text
header JSON
→ eyJhbGciOiJIUzI1NiIsImtpZCI6InBheW1lbnQta2V5LTEifQ

payload JSON
→ eyJhbW91bnQiOjEwMDAwMCwiZGVzdGluYXRpb24iOiJhY2NvdW50LTEyMyJ9
```

Base64URL changes regular Base64 like this:

```text
Same input bytes: FB FF

Regular Base64: +/8=
JOSE Base64URL: -_8

+ becomes -
/ becomes _
trailing = is removed
```

Base64URL is only an encoding. It makes bytes safe to carry as text; it does not provide secrecy or trust.

The signing input is the two encoded values joined by exactly one ASCII dot:

```text
eyJhbGciOiJIUzI1NiIsImtpZCI6InBheW1lbnQta2V5LTEifQ.eyJhbW91bnQiOjEwMDAwMCwiZGVzdGluYXRpb24iOiJhY2NvdW50LTEyMyJ9
```

```text
signingInput = ASCII(encodedProtectedHeader + "." + encodedPayload)
```

The exact bytes matter. Changing JSON whitespace, member order, number formatting, or any payload byte changes the signing input.

References: [RFC 4648 §5](https://www.rfc-editor.org/rfc/rfc4648.html#section-5), [RFC 7515 §§2 and 5.1](https://www.rfc-editor.org/rfc/rfc7515.html#section-5.1), [RFC 8725 §2.6](https://www.rfc-editor.org/rfc/rfc8725.html#section-2.6).

---

## Step 5 — calculate the signature or MAC

For this example, the profile uses `HS256`:

```text
demoSecret = UTF8("0123456789abcdef0123456789abcdef")

HMAC-SHA-256(demoSecret, signingInput)
→ 32 MAC bytes

Base64URL(MAC bytes)
→ Dwd8-NpRCCC8E1FodDCkI1ugNKAmCnler90B253rOCY
```

Append the encoded MAC as the third part:

```text
encodedHeader.encodedPayload.encodedMAC
```

Complete compact JWS:

```text
eyJhbGciOiJIUzI1NiIsImtpZCI6InBheW1lbnQta2V5LTEifQ.eyJhbW91bnQiOjEwMDAwMCwiZGVzdGluYXRpb24iOiJhY2NvdW50LTEyMyJ9.Dwd8-NpRCCC8E1FodDCkI1ugNKAmCnler90B253rOCY
```

References: [RFC 7515 §5.1](https://www.rfc-editor.org/rfc/rfc7515.html#section-5.1), [RFC 7518 §§3.2 and 3.4](https://www.rfc-editor.org/rfc/rfc7518.html#section-3.2).

---

## Step 6 — verify before trusting the payload

```mermaid
flowchart LR
    T["Receive compact JWS"] --> P["Require exactly 3 parts"]
    P --> H["Decode and parse protected header"]
    H --> A["Require profile-approved alg"]
    A --> K["Resolve kid inside trusted keys"]
    K --> I["Rebuild header.payload signing input"]
    I --> V["Verify signature or MAC"]
    V --> C["Only now consume payload"]
```

For our example, the receiver:

1. Requires three compact parts.
2. Reads `alg: HS256` and `kid: payment-key-1`.
3. Confirms that its payment profile allows `HS256`.
4. Finds `payment-key-1` only inside its configured trusted keys.
5. Recalculates HMAC-SHA-256 over the received `encodedHeader.encodedPayload`.
6. Compares the received and calculated MACs using a constant-time comparison.
7. Rejects the complete JWS if any step fails.

References: [RFC 7515 §5.2](https://www.rfc-editor.org/rfc/rfc7515.html#section-5.2), [RFC 7518 §3.2](https://www.rfc-editor.org/rfc/rfc7518.html#section-3.2), [RFC 7519 §7.2](https://www.rfc-editor.org/rfc/rfc7519.html#section-7.2), [RFC 8725 §§3.1–3.4](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.1).

---

## Step 7 — understand protected and unprotected headers

A JWS can have two header locations:

| Header | Covered by signature/MAC? | Where available? |
|---|---:|---|
| Protected header | Yes | Compact and JSON serializations |
| Unprotected header | No | JSON serializations only |

Compact serialization has only a protected-header part. JSON serialization can additionally contain an unprotected `header` object.

Common header parameters:

| Parameter | Meaning | Receiver rule |
|---|---|---|
| `alg` | Signature or MAC algorithm | Must be protected, understood, and profile-approved |
| `kid` | Hint for locating a candidate key | Does not prove the key is trusted |
| `typ` | Type of the complete object | Use to separate token kinds when the profile requires it |
| `cty` | Type of the payload | Common for nested JOSE objects |
| `crit` | Extensions that must be understood | Reject when any listed extension is unsupported |

Security-relevant decisions must come from protected data plus the receiver's local profile.

References: [RFC 7515 §§3 and 4.1](https://www.rfc-editor.org/rfc/rfc7515.html#section-3), [RFC 8725 §§3.1, 3.11, and 3.12](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.1).

---

## Step 8 — detached and unencoded payloads

Sometimes the payload already travels separately—for example, as the HTTP request body. A detached compact JWS leaves its middle segment empty:

```text
encodedProtectedHeader..encodedSignature
                       ↑ payload is not repeated here
```

The payload is still part of signature verification. The verifier must receive the exact payload bytes from elsewhere.

Detached payload and unencoded payload are separate choices:

- **Detached:** omit the payload from the serialized JWS.
- **`b64: false`:** use the raw payload bytes instead of their Base64URL encoding in the signing input.

A hypothetical request-signing example uses both. Its protected header is:

```json
{
  "alg": "ES256",
  "b64": false,
  "crit": ["b64"],
  "kid": "example-signing-key-1",
  "example_request_id": "example-request-123"
}
```

The signing input becomes:

```text
ASCII(BASE64URL(protectedHeader) + ".") || rawPayloadBytes
```

For an HTTP body containing the payment JSON:

```text
encodedProtectedHeader + "." + rawHTTPBodyBytes
```

The value sent in the illustrative `X-Example-JWS-Signature` header is:

```text
BASE64URL(protectedHeader)..BASE64URL(signature)
```

When `b64` is false, it must be protected and listed in `crit`. A verifier that does not understand this changed signing-input rule must reject the JWS.

References: [RFC 7515 Appendix F — detached content](https://www.rfc-editor.org/rfc/rfc7515.html#appendix-F), [RFC 7797 §§3–5](https://www.rfc-editor.org/rfc/rfc7797.html#section-3)

---

## JWS recap

```text
Purpose       = protect integrity/authenticity, not confidentiality
Logical parts = header + payload + signature/MAC
Compact form  = encodedHeader.encodedPayload.encodedSignature
Signing input = exact encodedHeader + "." + encodedPayload
Trust         = verify first, then consume the payload
```

Remember:

- Base64URL is encoding, not encryption.
- Decoding is not verification.
- `alg` must match the receiver's allow-list.
- `kid` helps select a key; it does not make the key trusted.
- Any failed parsing, policy, key-selection, or verification step rejects the JWS.

References: [RFC 7515 §§5 and 7](https://www.rfc-editor.org/rfc/rfc7515.html#section-5), [RFC 8725 §§3.1–3.4](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.1).

---

## JWA: JSON Web Algorithms

**JWA** stands for **JSON Web Algorithms**.

JWA gives JOSE algorithms standard names and defines exactly what those names mean. Without JWA, one team could write `ES256` while another team interprets its curve, hash, key format, or signature bytes differently.

JWA is not a cryptographic algorithm itself. It is the standard dictionary and rulebook used by JWS, JWE, and JWK.

Examples:

| JWA name | Meaning |
|---|---|
| `HS256` | HMAC using SHA-256 |
| `ES256` | ECDSA using the P-256 curve and SHA-256 |
| `A256GCM` | AES-GCM using a 256-bit key |
| `RSA-OAEP-256` | RSA-OAEP key encryption using SHA-256 |

Reference: [RFC 7518 §1](https://www.rfc-editor.org/rfc/rfc7518.html#section-1).

---

## Where JWA names appear

The meaning of a header parameter depends on the JOSE object:

| Object | Parameter | Job | Example |
|---|---|---|---|
| JWS | `alg` | Creates or verifies the signature/MAC | `HS256`, `ES256` |
| JWE | `alg` | Establishes or protects the content-encryption key | `RSA-OAEP-256`, `ECDH-ES` |
| JWE | `enc` | Encrypts and authenticates the actual plaintext | `A256GCM` |
| JWK | `alg` | Declares the algorithm intended for the key | `ES256` |

JWS needs one cryptographic operation:

```json
{
  "alg": "ES256"
}
```

References: [RFC 7518 §§3–5](https://www.rfc-editor.org/rfc/rfc7518.html#section-3), [RFC 7516 §4.1](https://www.rfc-editor.org/rfc/rfc7516.html#section-4.1).

---

## The application chooses an allow-list

The client and server profile must define the allowed algorithms in advance:

The verifier must ensure that:

1. the header algorithm is understood;
2. the application profile allows it;
3. the selected key is appropriate for it; and
4. the cryptographic verification succeeds.

References: [RFC 8725 §§3.1–3.2](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.1), [IANA JOSE Algorithms Registry](https://www.iana.org/assignments/jose/jose.xhtml#web-signature-encryption-algorithms).

---

## HS256 versus ES256

Both appear in a JWS `alg` header, but they use different key models:

| Question | `HS256` | `ES256` |
|---|---|---|
| Full operation | HMAC-SHA-256 | ECDSA P-256 with SHA-256 |
| Key model | One shared secret | Private/public key pair |
| Producer uses | Shared secret | Private key |
| Verifier uses | The same shared secret | Public key |
| Can the verifier create valid output? | Yes | No |

```text
HS256: message + shared secret → MAC
ES256: message + private key   → signature
```

They are not interchangeable merely because both use SHA-256. Choosing between them changes who can create valid output and how keys must be distributed and protected.

References: [RFC 7518 §3.2 — HMAC](https://www.rfc-editor.org/rfc/rfc7518.html#section-3.2), [RFC 7518 §3.4 — ECDSA](https://www.rfc-editor.org/rfc/rfc7518.html#section-3.4), [NIST FIPS 198-1](https://csrc.nist.gov/pubs/fips/198-1/final), [NIST FIPS 186-5](https://csrc.nist.gov/pubs/fips/186-5/final).

---

## JWT: JSON Web Token

**JWT** stands for **JSON Web Token**.

JWT defines how to represent a set of claims as a JSON object and carry those claims inside JWS or JWE.

JWT is not the same as one claim:

```text
Claim      = one statement
Claims Set = a JSON object containing claims
JWT        = the Claims Set carried inside JWS or JWE
```

Example:

```json
{
  "aud": "payment-service",
  "amount": 100000
}
```

`aud` and `amount` are individual claims. The complete JSON object is the Claims Set. It becomes a JWT when packaged using JWS or JWE.

Reference: [RFC 7519 §§2–3](https://www.rfc-editor.org/rfc/rfc7519.html#section-2).

---

## Registered and application-specific claims

RFC 7519 registers common claim names so producers and consumers give them the same meaning:

| Claim | Meaning | Example | Consumer check |
|---|---|---|---|
| `iss` | Issuer | `device-123` | Is this the expected issuer? |
| `sub` | Subject | `customer-42` | Is this the expected subject? |
| `aud` | Audience | `payment-service` | Is this service an intended audience? |
| `exp` | Expiration time | `1760000300` | Has the token expired? |
| `nbf` | Not valid before | `1760000000` | Is the token active yet? |
| `iat` | Issued-at time | `1760000000` | Is its age acceptable? |
| `jti` | Unique JWT identifier | `transaction-456` | Has it already been used? |

Applications may add their own claims:

```json
{
  "amount": 100000,
  "payment_type": "one-click"
}
```

`exp`, `nbf`, and `iat` use **NumericDate**: seconds since `1970-01-01T00:00:00Z`.

JWT defines what registered claims mean, but it does not require every token to contain all of them. The client/server profile defines which claims are required and how they are validated.

References: [RFC 7519 §§2 and 4.1](https://www.rfc-editor.org/rfc/rfc7519.html#section-4.1), [RFC 8725 §§3.8–3.10](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.8).

---

## JWT recap

```text
JWT    = JSON claims and their standard meanings
JWS    = integrity/authenticity protection for a JWT
JWE    = confidentiality/integrity protection for a JWT
Decode = read what the token says
Verify = check its cryptographic protection
Validate = decide whether its claims are acceptable
```

References: [RFC 7519 §§4 and 7](https://www.rfc-editor.org/rfc/rfc7519.html#section-4), [RFC 8725 §3](https://www.rfc-editor.org/rfc/rfc8725.html#section-3).

---

## JWK: JSON Web Key

**JWK** stands for **JSON Web Key**.

JWK is a standard JSON representation of a cryptographic key and information describing how that key is intended to be used.

Example-only P-256 public key:

```json
{
  "kty": "EC",
  "crv": "P-256",
  "x": "iV1QTNsgEGn1nHOTxD7lAMXKwOeunrLem6y2oVbnDzQ",
  "y": "P1MXKU6NKnC2Uex3r8BlLSqhqGp78dteAu-TdHnrfek",
  "use": "sig",
  "alg": "ES256",
  "kid": "example-signing-key-2"
}
```

| Field | Meaning |
|---|---|
| `kty: EC` | This is an elliptic-curve key |
| `crv: P-256` | The key uses the P-256 curve |
| `x`, `y` | Base64URL-encoded public-key coordinates |
| `use: sig` | The key is intended for signatures |
| `alg: ES256` | The intended JOSE algorithm |
| `kid` | An identifier used to find this key |

Only public-key JWKs are normally safe to publish. Never log or publish private or symmetric key material.

References: [RFC 7517 §§2 and 4](https://www.rfc-editor.org/rfc/rfc7517.html#section-2), [RFC 7518 §6.2](https://www.rfc-editor.org/rfc/rfc7518.html#section-6.2).

---

## JWKS: JSON Web Key Set

**JWKS** stands for **JSON Web Key Set**. It is a JSON object containing an array of JWKs:

```text
JWKS
└── keys
    ├── JWK with kid = payment-key-1
    └── JWK with kid = payment-key-2
```

A server can publish both an old and a new public key during key rotation.

References: [RFC 7517 §§4–5](https://www.rfc-editor.org/rfc/rfc7517.html#section-4), [RFC 8725 §§3.1 and 3.4](https://www.rfc-editor.org/rfc/rfc8725.html#section-3.1).

---

## JWE: JSON Web Encryption

**JWE** stands for **JSON Web Encryption**.

JWE defines how to encrypt data and package everything the recipient needs to decrypt it safely.

We will use this example:

```json
{
  "amount": 100000,
  "destination": "account-123"
}
```

The mobile app wants only the payment server to read this JSON.

```text
JWS: payload stays readable; signature/MAC protects it
JWE: payload becomes unreadable ciphertext and is integrity-protected
```

JWE provides:

- **Confidentiality:** someone without the decryption key cannot read the payment.
- **Integrity:** changing the protected header or encrypted content makes decryption authentication fail.

Reference: [RFC 7516 §§1 and 3](https://www.rfc-editor.org/rfc/rfc7516.html#section-1).

---

## JWE example — keys and algorithms

Assume:

- The app has the server's **public key**.
- Only the server has the matching **private key**.
- The app creates a new random 256-bit **content-encryption key (CEK)** for this message.

The protected header is:

```json
{
  "alg": "RSA-OAEP-256",
  "enc": "A256GCM",
  "kid": "recipient-key-7"
}
```

- `alg: RSA-OAEP-256` means: encrypt the CEK with the server's public key.
- `enc: A256GCM` means: encrypt and authenticate the payment using the CEK.
- `kid` tells the server which private key should be considered.

#### `alg` handles the key. `enc` handles the content.

Why use two operations?

```text
CEK encrypts the potentially large payment data.
Server public key protects the small CEK.
```

References: [RFC 7516 §§4.1 and 5](https://www.rfc-editor.org/rfc/rfc7516.html#section-4.1), [RFC 7518 §§4–5](https://www.rfc-editor.org/rfc/rfc7518.html#section-4).

---

## JWE example — sender steps

The mobile app:

1. Creates a random CEK.
2. Creates a unique IV for AES-GCM.
3. Encrypts the payment JSON with the CEK using `A256GCM`.
4. Receives two outputs: ciphertext and an authentication tag.
5. Encrypts the CEK with the server's public key using `RSA-OAEP-256`.
6. Base64URL-encodes the five JWE parts and joins them with dots.

```text
Payment JSON
    ↓ encrypt with CEK using A256GCM
Ciphertext + authentication tag

CEK
    ↓ encrypt with server public key using RSA-OAEP-256
Encrypted CEK
```

Reference: [RFC 7516 §5.1](https://www.rfc-editor.org/rfc/rfc7516.html#section-5.1).

---

## JWE example — the five compact parts

```text
header.encrypted-key.iv.ciphertext.authentication-tag
```

| Part | Contains in our example |
|---|---|
| Header | `RSA-OAEP-256`, `A256GCM`, and `recipient-key-7` |
| Encrypted key | The CEK encrypted with the server's public key |
| IV | The unique AES-GCM initialization value |
| Ciphertext | The encrypted payment JSON |
| Authentication tag | The value used to detect modification |

All five values are Base64URL-encoded and joined with dots.

Reference: [RFC 7516 §§3.1 and 7.1](https://www.rfc-editor.org/rfc/rfc7516.html#section-3.1).

---

## JWE example — recipient steps

The payment server:

1. Splits the compact JWE into five parts.
2. Reads the protected header and enforces its JWE profile.
3. Uses `kid` to select a trusted private-key candidate.
4. Decrypts the encrypted CEK with its private key.
5. Uses the recovered CEK, IV, protected header, ciphertext, and tag with `A256GCM`.
6. If authentication succeeds, it receives the original payment JSON.
7. If any step fails, it rejects the complete JWE and releases no plaintext.

```text
Encrypted CEK + server private key → CEK
Ciphertext + CEK + IV + tag        → original payment JSON
```

Reference: [RFC 7516 §5.2](https://www.rfc-editor.org/rfc/rfc7516.html#section-5.2).

---

## JWS versus JWE

| Question | JWS | JWE |
|---|---|---|
| What is it? | Integrity/authenticity container | Confidentiality/integrity container |
| Typical compact parts | 3 | 5 |
| Is payload readable? | Yes | No without decryption key |

References: [RFC 7515](https://www.rfc-editor.org/rfc/rfc7515.html), [RFC 7516](https://www.rfc-editor.org/rfc/rfc7516.html), [RFC 7519](https://www.rfc-editor.org/rfc/rfc7519.html).

---

## Primary references for further study

- [RFC 4648 — Base-N Encodings](https://www.rfc-editor.org/rfc/rfc4648.html)
- [RFC 7515 — JSON Web Signature](https://www.rfc-editor.org/rfc/rfc7515.html)
- [RFC 7516 — JSON Web Encryption](https://www.rfc-editor.org/rfc/rfc7516.html)
- [RFC 7517 — JSON Web Key](https://www.rfc-editor.org/rfc/rfc7517.html)
- [RFC 7518 — JSON Web Algorithms](https://www.rfc-editor.org/rfc/rfc7518.html)
- [RFC 7519 — JSON Web Token](https://www.rfc-editor.org/rfc/rfc7519.html)
- [RFC 7797 — JWS Unencoded Payload Option](https://www.rfc-editor.org/rfc/rfc7797.html)
- [RFC 8725 — JWT Best Current Practices](https://www.rfc-editor.org/rfc/rfc8725.html)
- [IANA JOSE Registries](https://www.iana.org/assignments/jose/jose.xhtml)
- [NIST FIPS 198-1 — HMAC](https://csrc.nist.gov/pubs/fips/198-1/final)
- [NIST FIPS 186-5 — Digital Signature Standard](https://csrc.nist.gov/pubs/fips/186-5/final)
- [NIST SP 800-38D — GCM and GMAC](https://csrc.nist.gov/pubs/sp/800/38/d/final)
- [Apple Security — `SecKeyCreateSignature`](https://developer.apple.com/documentation/security/seckeycreatesignature%28_%3A_%3A_%3A_%3A%29)
- [Apple CryptoKit — P-256 ECDSA signature representations](https://developer.apple.com/documentation/cryptokit/p256/signing/ecdsasignature/rawrepresentation)
- [OWASP REST Security — JWT](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html#jwt)
