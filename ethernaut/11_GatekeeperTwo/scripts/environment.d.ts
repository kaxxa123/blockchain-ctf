declare global {
    namespace NodeJS {
        interface ProcessEnv {
            MNEMONIC: string;
            PROJECT_ID: string;
            PRIVATE_KEY_1: string;
        }
    }
}

export {}