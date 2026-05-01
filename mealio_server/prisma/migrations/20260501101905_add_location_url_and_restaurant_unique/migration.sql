/*
  Warnings:

  - A unique constraint covering the columns `[name,address]` on the table `Restaurant` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Restaurant" ADD COLUMN     "locationUrl" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Restaurant_name_address_key" ON "Restaurant"("name", "address");
