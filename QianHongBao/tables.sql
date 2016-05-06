CREATE TABLE IF NOT EXISTS "message" (
    "mid" INTEGER NOT NULL,
    "id"  INTEGER NOT NULL,
    "rid" INTEGER NOT NULL,
    "uid" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "nackname" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "status" INTEGER NOT NULL,
    "type" INTEGER NOT NULL,
    "bonus_total" FLOAT NOT NULL,
    "dsTime" INTEGER NOT NULL,
    "photo" TEXT NOT NULL,
    PRIMARY KEY("mid")
);
