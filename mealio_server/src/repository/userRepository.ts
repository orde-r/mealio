import prisma from "../prisma";

export async function findExistingUser(email: string) {
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
  });
  return user;
}

export async function createUser(userData: {
  email: string;
  password: string;
  name: string;
}) {
  const newUser = await prisma.user.create({
    data: {
      email: userData.email,
      password: userData.password,
      name: userData.name,
    },
  });
  return newUser;
}

export async function findUserById(userId: string) {
  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
  });
  return user;
}

export async function updateUsername(userId: string, newName: string) {
  const updatedUser = await prisma.user.update({
    where: {
      id: userId,
    },
    data: {
      name: newName,
    },
  });
  return updatedUser;
}

export async function updatePassword(
  userId: string,
  hashedNewPassword: string,
) {
  const user = await prisma.user.update({
    where: {
      id: userId,
    },
    data: {
      password: hashedNewPassword,
    },
  });
  return user;
}

export async function updatePreferences(
  userId: string,
  requiresHalal: boolean,
  requiresVegan: boolean,
  allergies: string[],
) {
  const user = await prisma.user.update({
    where: {
      id: userId,
    },
    data: {
      hasCompletedOnboarding: true,
      requiresHalal,
      requiresVegan,
      allergies,
    },
  });
  return user;
}

export async function updateOnboardingStatus(
  userId: string,
  hasCompletedOnboarding: boolean,
) {
  const user = await prisma.user.update({
    where: {
      id: userId,
    },
    data: {
      hasCompletedOnboarding,
    },
  });
  return user;
}
