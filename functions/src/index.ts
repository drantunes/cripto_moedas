import * as functions from "firebase-functions";
import { Client } from "@notionhq/client";

// 1. Configurar o Notion e habilitar a API 
// 2. Com as credenciais em mãos, definir variáveis de ambiente via Terminal
// 3. Executar o comando abaixo, substituindo com suas credenciais de acesso: 
// firebase functions:config:set notion.database.id="1234" notion.key="secret_1234"
// 4. Para trabalhar com o emulador, localmente, execute na dentro da pasta functions: 
// firebase functions:config:get > .runtimeconfig.json

const notion = new Client({ auth: functions.config().notion.key });
const databaseId = functions.config().notion.database.id;

export const enviarEmailParaNotion = functions.auth.user().onCreate(
    async user => {
        const userEmail: any = user.email;

        try {
            await notion.pages.create(<any>{
                parent: { database_id: databaseId },
                properties: {
                    Email: {
                        title: [{ type: "text", text: { content: userEmail } }],
                    },
                    Etapa: {
                        multi_select: [{ name: "Novo Cadastro" }]
                    },
                },
            });
            console.log('AUTH: Sincronização com Notion realizada com sucesso.');
        } catch (error) {
            console.log('AUTH: Erro na Sincronização com Notion.');
        }
        return true;
    }
);