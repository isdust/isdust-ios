//
//  rsa.c
//  isdust_ios
//
//  Created by wzq on 7/26/16.
//  Copyright © 2016 isdust. All rights reserved.
//

#include "rsa.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include<openssl/md5.h>
#include <openssl/rsa.h>
#include <openssl/engine.h>
#include <openssl/pem.h>
#include "base64.h"
#define PADDING RSA_PKCS1_PADDING
//#define PADDING RSA_NO_PADDING
const char *b64_pKey = "-----BEGIN PUBLIC KEY-----\n"
"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0VjXgLkmH+BqDryOPCZn\n"
"mLItfrGbhyk4sLLGYUZkgIprZ6iWQ9WAB+GXhmLcKIlMZKoEXhN7ReA59RTB1iKr\n"
"A4VuVxu2CU1ZV7MJLwu3yVkymeUjRm/xm55SeteFc/NBxFdmJO/SnFic2VZJpXb7\n"
"+vFiXsKr5Wc7N3L1YyQS16CNevSjhbTCRVPvX+8tqrFB8UJYUyrW9Y10yZ1fF3wF\n"
"LqrT8/lKQXpc2PMLsgDgjAb3MEyGWC3i4iklUX/IekjtuYrnk1R0fDg8AWypuMp8\n"
"N2jHOYE4kJjLmQtUnAFRg/TE3AysD8FVoCQ1fz6fhF08Zj4Lamfv3mBM/XC9hN7J\n"
"cQIDAQAB\n"
"-----END PUBLIC KEY-----";
RSA* loadPUBLICKeyFromString( const char* publicKeyStr )
{
    // A BIO is an I/O abstraction (Byte I/O?)
    
    // BIO_new_mem_buf: Create a read-only bio buf with data
    // in string passed. -1 means string is null terminated,
    // so BIO_new_mem_buf can find the dataLen itself.
    // Since BIO_new_mem_buf will be READ ONLY, it's fine that publicKeyStr is const.
    BIO* bio = BIO_new_mem_buf( (void*)publicKeyStr, -1 ) ; // -1: assume string is null terminated
    
    BIO_set_flags( bio, BIO_FLAGS_BASE64_NO_NL ) ; // NO NL
    
    // Load the RSA key from the BIO
    RSA* rsaPubKey = PEM_read_bio_RSA_PUBKEY( bio, NULL, NULL, NULL ) ;
    if( !rsaPubKey )
        printf( "ERROR: Could not load PUBLIC KEY!  PEM_read_bio_RSA_PUBKEY FAILED: %s\n", ERR_error_string( ERR_get_error(), NULL ) ) ;
    
    BIO_free( bio ) ;
    return rsaPubKey ;
}


unsigned char* rsaEncrypt( RSA *pubKey, const unsigned char* str, int dataSize, int *resultLen )
{
    int rsaLen = RSA_size( pubKey ) ;
    unsigned char* ed = (unsigned char*)malloc( rsaLen ) ;
    
    // RSA_public_encrypt() returns the size of the encrypted data
    // (i.e., RSA_size(rsa)). RSA_private_decrypt()
    // returns the size of the recovered plaintext.
    *resultLen = RSA_public_encrypt( dataSize, (const unsigned char*)str, ed, pubKey, PADDING ) ;
    if( *resultLen == -1 )
        printf("ERROR: RSA_public_encrypt: %s\n", ERR_error_string(ERR_get_error(), NULL));
    
    return ed ;
}

unsigned char* rsaDecrypt( RSA *privKey, const unsigned char* encryptedData, int *resultLen )
{
    int rsaLen = RSA_size( privKey ) ; // That's how many bytes the decrypted data would be
    
    unsigned char *decryptedBin = (unsigned char*)malloc( rsaLen ) ;
    *resultLen = RSA_private_decrypt( RSA_size(privKey), encryptedData, decryptedBin, privKey, PADDING ) ;
    if( *resultLen == -1 )
        printf( "ERROR: RSA_private_decrypt: %s\n", ERR_error_string(ERR_get_error(), NULL) ) ;
    
    return decryptedBin ;
}

char* rsaEncryptThenBase64( RSA *pubKey, unsigned char* binaryData, int binaryDataLen, int *outLen )
{
    int encryptedDataLen ;
    
    // RSA encryption with public key
    unsigned char* encrypted = rsaEncrypt( pubKey, binaryData, binaryDataLen, &encryptedDataLen ) ;
    
    // To base 64
    int asciiBase64EncLen ;
    char* asciiBase64Enc = base64( encrypted, encryptedDataLen, &asciiBase64EncLen ) ;
    
    // Destroy the encrypted data (we are using the base64 version of it)
    free( encrypted ) ;
    
    // Return the base64 version of the encrypted data
    return asciiBase64Enc ;
}
char* openssl_rsa_encrypt(unsigned char* data){
    int asciiB64ELen ;
    
    ERR_load_crypto_strings();
    RSA *pubKey = loadPUBLICKeyFromString( b64_pKey ) ;
    char* asciiB64E = rsaEncryptThenBase64( pubKey, data, strlen(data), &asciiB64ELen ) ;
    RSA_free( pubKey ) ;
    ERR_free_strings();
    return asciiB64E;
    
}

char * openssl_md5(unsigned char *data){
    unsigned char md[16];
    int i;
    char tmp[3]={'\0'};
    char *buf=(char *)malloc(sizeof(char)*33);
    memset(buf,0,sizeof(char)*33);
    MD5(data,strlen(data),md);
    for (i = 0; i < 16; i++){
        sprintf(tmp,"%02X",md[i]);
        strcat(buf,tmp);
    }
    return buf;
}
