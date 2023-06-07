declare global {
    namespace NodeJS {
        interface ProcessEnv {
            MNEMONIC: string;
            PROJECT_ID: string;
            PRIVATE_KEY_1: string;
            PRIVATE_KEY_2: string;
        }
    }
}

export {}